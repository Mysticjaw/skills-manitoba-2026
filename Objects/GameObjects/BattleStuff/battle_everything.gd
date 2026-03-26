extends Node2D

var playerWheel: Node

var menuCage: Node

var outerCage: Node

var parent: Node

var turningDirection: int = 0

var players: Array[Node]

var rotatingTarget: float = 0

const ROTATE_SPEED: int = 10

var currentFront: int = 1

var controlable: bool = true
var inMenu: bool = false

var rotating: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerWheel = get_node("playerWheel")
	menuCage = get_node("menuCage")
	outerCage = get_node("outerCage")
	parent = get_parent()
	parent.battle = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("trueBtnB") && controlable && inMenu:
		players[currentFront].followPos = players[currentFront].MAIN_VAL
		get_parent().bringToFront(players[currentFront])
		inMenu = false
	if ((Input.is_action_just_pressed("trueLeft") && rotating) || Input.is_action_just_pressed("trueTriggerL")) && controlable && inMenu:
		print("left")
		var amountMoved: int = 0
		var nextFront = currentFront
		var findingFront = true
		while findingFront:
			nextFront -= 1
			amountMoved += 1
			if nextFront == 0:
				nextFront += players.size() - 1
				print("moving to top")
			if nextFront == currentFront:
				print("EVERYONE IS DEAD")
			elif MiscGlobals.healths[players[nextFront].charVal] != 0:
				print("sucessfully selected")
				currentFront = nextFront
				findingFront = false
			
		rotatingTarget = playerWheel.rotation - ((2 * PI / (players.size() - 1)) * amountMoved)
		turningDirection = -1
		print("AAAAAAAAAAAAAAAAAAAAAAAA")
		controlable = false
	if ((Input.is_action_just_pressed("trueRight") && rotating) || Input.is_action_just_pressed("trueTriggerR")) && controlable && inMenu:
		print("right")
		var amountMoved: int = 0
		var nextFront = currentFront
		var findingFront = true
		while findingFront:
			nextFront += 1
			amountMoved += 1
			if nextFront == players.size():
				nextFront -= players.size() - 1
				print("moving to top")
			if nextFront == currentFront:
				print("EVERYONE IS DEAD")
			elif MiscGlobals.healths[players[nextFront].charVal] != 0:
				("sucessfully selected")
				currentFront = nextFront
				findingFront = false
			
		rotatingTarget = playerWheel.rotation + ((2 * PI / (players.size() - 1)) * amountMoved)
		turningDirection = 1
		controlable = false
	playerWheel.rotation += turningDirection * delta * ROTATE_SPEED
	if playerWheel.rotation * turningDirection >= rotatingTarget * turningDirection && inMenu:
		playerWheel.rotation = rotatingTarget
		turningDirection = 0
		controlable = true

func prepareBattle(playersNew: Array[Node]):
	players.resize(1)
	for i in playersNew.size():
		print(i)
		print(playersNew.size())
		if playersNew[i].charVal == playersNew[i].SUPPORT_VAL:
			players[0] = playersNew[i]
			players[0].battleStart(get_node("holder0"))
		else:
			players.resize(players.size() + 1)
			players[players.size() - 1] = playersNew[i]
			print("playerWheel/holder" + str(players.size() - 1))
			players[players.size() - 1].battleStart((get_node("playerWheel/holder" + str(players.size() - 1))))
		
	
