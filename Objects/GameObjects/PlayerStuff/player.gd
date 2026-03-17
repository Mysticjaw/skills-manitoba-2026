extends CharacterBody2D
#preparing nodes
@onready var sprite = get_node("playerSprite")
@onready var anim = get_node("playerAnimations")
@onready var hitbox = get_node("playerHitbox")
@onready var parent = get_parent()
#what direction am I facing (vertically)
var storedY: int = 0
#what direction am I facing (horizontally)
var storedX: int = 1
# variables for following/followers
var periodTimer: float = 0
#a followpos of 0 means it's in your control
#a followpos of over 0 means it's following one of a followpos of 0
#a followpos of -1 means you have absolutely no control
#a followpos of -2 means it's sliding to a position and will change when it gets there
#a followpos fo -3 means it's in the battlemenu
var followPos: int

var movingTime: float = 0
var cameraMoving: bool = true
#constants
const PERIOD: float = 0.05	#how oftan do you update past locations
const POS_FREQ: int = 4	#how many past positions per placement
const SPEED = 350.0	#speed
const CAMERA_AHEAD: int = 1	#how ahead the camera should be
const CAM_FREEZE_AREA = 100
#the values for followPos
const MAIN_VAL: int = 0
const NOTHING_VAL: int = -1
const SLIDE_VAL: int = -2
const WAIT_VAL: int = -3
const BATTLE_VAL: int = -4

#is the player in your control
var movable: bool = true

#for sliding the player places
var slidingTo: Array[Vector2]
var nextFollowPos: int = 0
var slideTimes: Array[float] = [0]
var slideWalking: bool = true

var battleSpot: Node

func _ready() -> void:
	print()
	global_position = MiscGlobals.startPos
	#setting up metadatas to be accsessed more easily and setting up the initial varibles
	changeCharacter(get_meta("initChar"))
	storedY = get_meta("startDirection")
	if get_meta("startFlipped"):
		storedX = -1
	elif storedY == 0:
		storedX = 1
	followPos = get_meta("followLevel")
	
	if followPos == 0:
		parent.thisLocation = global_position
	if followPos >= 0:
		parent.setPlayer(self, followPos)

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
		if velocity.x < 0 && storedY == 0:	#if moving in that direction, flip it
			storedX = -1
		else:	#otherwise, don't
			if storedY:
				storedX = 0
			else:
				storedX = 1
		if velocity.y || velocity.x:	#if it's moving
			anim.play("move" + str(storedY) + str(storedX))	#play an ainimation based off of the Y direction
			if storedY != 0:	#if it's not facing horizontally it shouldn't be flipped
				storedX = 0
			periodTimer += delta	#this variable is just for counting so that it updates the past locations infrquently enough
			parent.moving = true	#mark in the parent that it's moving
			if periodTimer >= PERIOD:	#if the right amount of time has elapsed
				parent.thisLocation = global_position	#set the current location as thisLocations to be added to the list after the frame
				periodTimer -= PERIOD
			parent.periodTime = periodTimer	#update the timer to keep the followers on pace
			
			
		else:	#if it's stopped
			anim.play("stop" + str(storedY) + str(storedX))	#stopped facing in the direction
			parent.moving = false	#not moving
		if parent.cameraPos == global_position:
			movingTime = 0
			cameraMoving = false
		elif (abs(move_toward(0, parent.cameraPos.x - global_position.x, CAM_FREEZE_AREA)) == CAM_FREEZE_AREA
		|| abs(move_toward(0, parent.cameraPos.y - global_position.y, CAM_FREEZE_AREA)) == CAM_FREEZE_AREA):
			cameraMoving = true
		if cameraMoving:
			movingTime += delta
			parent.cameraPos.x = move_toward(parent.cameraPos.x, global_position.x + (velocity.x * CAMERA_AHEAD), abs(parent.cameraPos.x - global_position.x + (velocity.x * CAMERA_AHEAD)) * movingTime)
			parent.cameraPos.y = move_toward(parent.cameraPos.y, global_position.y + (velocity.y * CAMERA_AHEAD), abs(parent.cameraPos.y - global_position.y + (velocity.y * CAMERA_AHEAD)) * movingTime)
		move_and_slide()
	
	
	
	#if it's a follower
	#it works by setting it's position to a point in between two past locations based on the parent's periodTime
	elif followPos > 0:
		hitbox.disabled = true	#disable the hitboxes for followers, not nesessary, but maybe better this way to avoid future problems
		if !parent.pastLocations[(followPos*POS_FREQ)]:	#if the slot it's coming from doesn't exist, then update 
			parent.pastLocations[(followPos*POS_FREQ)] = global_position
		if parent.moving && parent.stepsTaken >= followPos * POS_FREQ:  #&& parent.pastLocations[followPos*POS_FREQ] != global_position:	#essentially is it following yet
			#print("MOVING")
			#getting the new position which is the spot along the space in between the past locations
			var newPos = parent.pastLocations[followPos*POS_FREQ] + ((parent.pastLocations[(followPos*POS_FREQ) - 1] - parent.pastLocations[followPos * POS_FREQ]) * parent.periodTime / PERIOD)
			if followPos == 1:
				print(newPos)
			if global_position.y - newPos.y != 0:	#sprite stuff, dependent on the direction it's moved this frame
				storedY = int(move_toward(0, 1/(global_position.y - newPos.y) + global_position.y - newPos.y, 1))
				storedX = 0
			#is it moving more horizontally than vertically?
			if abs(global_position.x - newPos.x) >= abs(global_position.y - newPos.y):
				storedY = 0
				storedX = int(move_toward(0, 1/(global_position.y - newPos.y) + global_position.y - newPos.y, 1))
				#set animation & position according to selected values
			anim.play("move" + str(storedY) + str(storedX))
			global_position = newPos
		else:
			#if parent.pastLocations[followPos*POS_FREQ] != global_position:
				#print("something is working here")
			if parent.moving && parent.stepsTaken >= followPos * POS_FREQ:
				print("MOVING BUT STILL STOPPED")
			anim.play("stop" + str(storedY) + str(storedX))
	else:
		#this will be for when in cutscenes, or in the battle menu, ect, so we can remove control of the player
		match followPos:
			SLIDE_VAL:
				if slideTimes[0] - delta <= 0:
					global_position = slidingTo[0]
					if slideTimes.size() > 1:
						slideTimes = MiscGlobals.removeFirst(slideTimes)
						slideTimes = MiscGlobals.removeFirst(slideTimes)
					else:
						followPos = nextFollowPos
						
				else:
					if abs(slidingTo[0].x - global_position.x) >= abs(slidingTo[0].y - global_position.y):
						storedY = 0
					else:
						storedY = int(move_toward(0, (1/(slidingTo[0].x - global_position.x)) + slidingTo[0].x - global_position.x, 1))
					if slideWalking:
						if storedY == 0:
							if slidingTo[0].x - global_position.x < 0:
								storedX = -1
							else:
								sprite.flip_h = false
						else:
							sprite.flip_h = false
						anim.play("move" + str(storedY))
					else:
						sprite.flip_h = false
					global_position += (slidingTo[0] - global_position) * (delta / slideTimes[0])
				
			
		
	
#change the character to one of a specific one based on a value (as in the sprite)
func changeCharacter(no: int):
	sprite.loadSprite("res://Objects/GameObjects/PlayerStuff/player"+str(no)+"SpriteFrames.tres")	

#start sliding somewhere
func slideTo(slidePos, times, next: int, walking: bool):
	if typeof(slidePos) == TYPE_PACKED_VECTOR2_ARRAY:
		slidingTo = slidePos
	elif typeof(slidePos) == TYPE_VECTOR2:
		slidingTo = [slidePos]
	else:
		print("slidePos wasn't a vector stupid")
		return
	if typeof(slidePos) == TYPE_PACKED_FLOAT32_ARRAY || typeof(slidePos) == TYPE_PACKED_FLOAT64_ARRAY:
		slideTimes = times
	elif typeof(slidePos) == TYPE_FLOAT:
		slideTimes = [times]
	else:
		print("slideTimes wasn't a float idiot")
		return
	nextFollowPos = next
	followPos = SLIDE_VAL
	slideWalking = walking


func battleTurnStart():
	slideTo([battleSpot.global_position], [0.5], BATTLE_VAL, false)

func battleStart(pinSpot: Node):
	battleSpot = pinSpot
	battleTurnStart()
