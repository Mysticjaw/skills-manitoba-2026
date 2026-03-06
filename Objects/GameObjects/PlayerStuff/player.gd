extends CharacterBody2D
#preparing nodes
@onready var sprite = get_node("playerSprite")
@onready var anim = get_node("playerAnimations")
@onready var hitbox = get_node("playerHitbox")
@onready var parent = get_parent()
#what direction am I facing (vertically)
var storedY: int = 0
# variables for following/followers
var periodTimer: float = 0
var followPos: int
#constants
const PERIOD: float = 0.05	#how oftan do you update past locations
const POS_FREQ: int = 4	#how many past positions per placement
const SPEED = 350.0	#speed
#is the player in your control
var movable: bool = true

func _ready() -> void:
	#setting up metadatas to be accsessed more easily and setting up the initial varibles
	changeCharacter(get_meta("initChar"))
	storedY = get_meta("startDirection")
	sprite.flip_h = get_meta("startFlipped")
	followPos = get_meta("followLevel")*POS_FREQ
	
	if followPos:	#checking if it's a follower or not to remove follower cameras
		get_node("Camera2D").enabled = false
	else:	#if it's the leader then you want the camera enabled
		get_node("Camera2D").enabled = true
		#to stop followers from starting off going to the center
		parent.thisLocation = global_position
	

#ah yes, physics
#the only ap course that somehow makes you less smart then you were when you started
func _physics_process(delta: float) -> void:
	if followPos == 0:	#this means it's in control
		hitbox.disabled = false	#you want the player to have a hitbox
		var directionY := Input.get_axis("trueUp", "trueDown")	#setting up directions
		var directionX := Input.get_axis("trueLeft", "trueRight")
		#this is for standerdizing the speed (I almost called it multiplier well knoing I was going to divide by it):
		var divider: float = sqrt((directionY * directionY) + (directionX * directionX))
		if divider != 0:	#don't want to divide by zero
			directionY /= divider	#wow. this line is actually insane.
			directionX /= divider	#holy fuck it happened again.
		if directionY:	#checking if the y direction is anything before setting velocity and another
						#variable that's used in choosing the sprite
			velocity.y = directionY * SPEED
			if directionY > 0:
				storedY = 1
			elif directionY < 0:
				storedY = -1	#I deeply opollogize for my actions a few comments ago, my language was unnessisary and profane, it will not happen again
		else:	#approach zero if not moving Y-ly
			velocity.y = move_toward(velocity.y, 0, SPEED)	#(shit I spelled apologize wrong)
		if directionX != 0:	#if directionX, chane the velocity accordingly
			velocity.x = directionX * SPEED
			if abs(directionX) >= abs(directionY):
				storedY = 0	#this means it's facing horizontaly
			
		else:	#approach zero
			velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.x < 0:	#if moving in that direction, flip it
			sprite.flip_h = true
		else:	#otherwise, don't
			sprite.flip_h = false
		if velocity.y || velocity.x:	#if it's moving
			anim.play("move" + str(storedY))	#play an ainimation based off of the Y direction
			if storedY != 0:	#if it's not facing horizontally it shouldn't be flipped
				sprite.flip_h = false
			periodTimer += delta	#this variable is just for counting so that it updates the past locations infrquently enough
			parent.moving = true	#mark in the parent that it's moving
			if periodTimer >= PERIOD:	#if the right amount of time has elapsed
				parent.thisLocation = global_position	#set the current location as thisLocations to be added to the list after the frame
				periodTimer -= PERIOD
			parent.periodTime = periodTimer	#update the timer to keep the followers on pace
			
			
		else:	#if it's stopped
			anim.play("stop" + str(storedY))	#stopped facing in the direction
			parent.moving = false	#not moving
		move_and_slide()
	
	
	
	#if it's a follower
	#it works by setting it's position to a point in between two past locations based on the parent's periodTime
	elif followPos > 0:
		hitbox.disabled = true	#disable the hitboxes for followers, not nesessary, but maybe better this way to avoid future problems
		if !parent.pastLocations[(followPos)]:	#if the slot it's coming from doesn't exist, then update 
			parent.pastLocations[(followPos)] = global_position
		if parent.moving && parent.stepsTaken >= followPos:	#essentially is it following yet
			#getting the new position which is the spot along the space in between the past locations
			var newPos = parent.pastLocations[followPos]+((parent.pastLocations[followPos-1]-parent.pastLocations[followPos])*parent.periodTime/PERIOD)
			if global_position.y - newPos.y < 0:	#sprite stuff, dependent on the direction it's moved this frame
				storedY = 1
				sprite.flip_h = false
			elif global_position.y - newPos.y > 0:
				storedY = -1
				sprite.flip_h = false
			elif global_position.x - newPos.x < 0:
				sprite.flip_h = false
			else:
				sprite.flip_h = true
			#is it moving more horizontally than vertically?
			if abs(global_position.x - newPos.x) >= abs(global_position.y - newPos.y):
				storedY = 0
				#set animation & position according to selected values
			anim.play("move" + str(storedY))
			global_position = newPos
		else:
			anim.play("stop" + str(storedY))
	else:
		
		
		#this will be for when in cutscenes, or in the battle menu, ect, so we can remove control of the player
		match -followPos:
			1:
				return
			
		
	
#change the character to one of a specific one based on a value (as in the sprite)
func changeCharacter(no: int):
	sprite.loadSprite("res://Objects/GameObjects/PlayerStuff/player"+str(no)+"SpriteFrames.tres")	
