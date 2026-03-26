extends StaticBody2D

#acess the raycasts
@onready var leftRay: Node = get_node("leftRay")
@onready var upRay: Node = get_node("upRay")
@onready var rightRay: Node = get_node("rightRay")
@onready var downRay: Node = get_node("downRay")

#the menu buttons in the various directions
var current: Node
var upwards: Node
var downwards: Node
var leftwards: Node
var rightwards: Node

#is a stick activeky being pressed
var stickPressed: bool = false

#can you select things
var confirmable: bool = false

#what's the actively selected tab (is this even being used? it stays just in case maybe I'll remove it later if I remember to)
var tab: Node

#what position did it start off at and what position to return to when resetting
var initPos: Vector2

#make the initPos the initial position
func _ready() -> void:
	initPos = global_position


#proceed.
func _process(_delta: float) -> void:
	if get_parent().visible && visible:	#menu items don't work in the background so you can disable them by hiding them
		if !current:	#if nothng is selected
			reset()	#go to initial position
			downRay.force_raycast_update()	#recast
			if downRay.is_colliding():
				instantSelect(downRay.get_collider())	#select the thing below it
			
		checkInvisibles()	#are any of the stored nodes invisible (if so, remove them from storage)
		if current:	#is anything selected?
			processMovement()	#move the selecter
			processDirections()	#deal with casted rays
			if Input.is_action_just_pressed("trueBtnA") && confirmable:	#if a is pressed then do a menu action
				get_parent().menuAction(current.get_meta("actionValue"), self)
			elif (Input.is_action_just_pressed("trueBtnX") || Input.is_action_just_pressed("trueBtnB")) && confirmable:	#if a form of go back is pressed return
				var fullRestore = !get_parent().get_node("settingsMenu").visible
				get_parent().restore(fullRestore)
			
		confirmable = true	#set confirmable based on if it's visible (active) or not
	else:
		confirmable = false

#move the selecter
func processMovement():
	#is it moving
	var moving: bool = false
	#directions
	var directionX: float = 0
	var directionY: float = 0
	if MiscGlobals.pad:	#only make the directions accurate if using controller (not needed otherwise)
		directionX = Input.get_axis("trueLeft", "trueRight")
		directionY = Input.get_axis("trueUp", "trueDown")
	if !stickPressed || !MiscGlobals.pad:	#if either using keyboard or not already holding a direction
		if (directionX < 0 && abs(directionX) > abs(directionY) && MiscGlobals.pad) || Input.is_action_just_pressed("trueLeft"):	#get input
				#update directions
				
			if leftwards:
				rightwards = current
				current = leftwards
				leftwards = null
				
				rightwards.selected = false
				current.selected = true
			#if pressing a direction makes a value change:
			elif current.has_method("valueChange"):
				current.valueChange(false)	#chsnge the value
			stickPressed =  true
			moving = true
		
			
		if ((directionY < 0 && abs(directionY) > abs(directionX) && MiscGlobals.pad) || Input.is_action_just_pressed("trueUp")) && !moving:	#get input
			#update directions
			if upwards:
				downwards = current
				current = upwards
				upwards = null
				
				downwards.selected = false
				current.selected = true
			stickPressed =  true
			moving = true
		
		if ((directionX > 0 && abs(directionX) > abs(directionY) && MiscGlobals.pad) || Input.is_action_just_pressed("trueRight")) && !moving:	#get input
			#update directions
			if rightwards:
				leftwards = current
				current = rightwards
				rightwards = null
				
				leftwards.selected = false
				current.selected = true
			#if pressing a direction makes a value change:
			elif current.has_method("valueChange"):
				current.valueChange(true)	#chsnge the value
			stickPressed =  true
			moving = true
		
		if ((directionY > 0 && abs(directionY) > abs(directionX) && MiscGlobals.pad) || Input.is_action_just_pressed("trueDown")) && !moving:	#get input
			#update directions
			if downwards:
				upwards = current
				current = downwards
				downwards = null
				
				upwards.selected = false
				current.selected = true
			stickPressed =  true
			moving = true
		
	
	if directionX == 0 && directionY == 0:
		stickPressed = false
	if !moving:
		return
	position = current.position
	processDirections()
	#play move sound

#this one used to be more complicated, I had a whole system of scannig
#the space between slots when changing, but tht was causing problems
#and so now it just only can move when directly out of sight
func processDirections():
	
	#if the ray is colliding then store it, otherwise clear
	if leftRay.is_colliding():
		leftwards = leftRay.get_collider()
	else:
		leftwards = null
		
	#if the ray is colliding then store it, otherwise clear
	if upRay.is_colliding():
		upwards = upRay.get_collider()
	else:
		upwards = null
	
	#if the ray is colliding then store it, otherwise clear
	if rightRay.is_colliding():
		rightwards = rightRay.get_collider()
	else:
		rightwards = null
	
	#if the ray is colliding then store it, otherwise clear
	if downRay.is_colliding():
		downwards = downRay.get_collider()
	else:
		downwards = null
	#I have no idea why this is in THIS method
	if current:
		global_position = current.global_position

#forget the old selectedness, select the new selectedness
func instantSelect(node: Node):
	if current:	#deselect
		current.selected = false
	#select instantly
	current = node
	current.selected = true
	#forget
	leftwards = null
	upwards = null
	rightwards = null
	downwards = null
	#YOU SHOULD RECAST YOURSELF NOW!
	leftRay.force_raycast_update()
	upRay.force_raycast_update()
	rightRay.force_raycast_update()
	downRay.force_raycast_update()


func checkInvisibles() -> void:
	#if this direction isn't visible remove it from the stored ones
	if upwards:
		if !upwards.visible:
			upwards = null
		
	#if this direction isn't visible remove it from the stored ones
	if downwards:
		if !downwards.visible:
			downwards = null
		
	#if this direction isn't visible remove it from the stored ones
	if leftwards:
		if !leftwards.visible:
			leftwards = null
		
	#if this direction isn't visible remove it from the stored ones
	if rightwards:
		if !rightwards.visible:
			rightwards = null
		
	#if this isn't visible deselect it and remove it from the stored ones
	if current:
		if !current.visible:
			current.selected = false
			current = null
			


#reset
func reset():
	#go back from whence you came
	global_position = initPos
	if current:
		#deselect
		current.selected = false
	#reset the stored nodes
	leftwards = null
	upwards = null
	rightwards = null
	downwards = null
	current = null
