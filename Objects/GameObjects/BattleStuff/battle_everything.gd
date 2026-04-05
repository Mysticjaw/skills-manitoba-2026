extends Node2D

@onready var playerWheel: Node = get_node("playerWheel")

@onready var menuCage: Node = get_node("menuCage")

@onready var outerCage: Node = get_node("outerCage")

@onready var parent: Node = get_parent()

var turningDirection: int = 0

var players: Array[Node]

var rotatingTarget: float = 0

const ROTATE_SPEED: int = 10

var currentFront: int = 1

var controlable: bool = true
var inMenu: bool = false

var rotating: bool = true

var currentTurn: int = 0

var turnsSelected: Array[String]

var currentActive: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent.battle = self
	turnsSelected.resize(players.size() - 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("trueBtnA") && controlable && inMenu:
		next()
	elif Input.is_action_just_pressed("trueBtnB") && controlable && inMenu:
		next()
	elif Input.is_action_just_pressed("trueBtnX") && controlable && inMenu:
		next()
	elif Input.is_action_just_pressed("trueBtnY") && controlable && inMenu:
		next()
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
				currentActive = currentFront
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
				currentActive = currentFront
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
		
	

func releasePlayer():
	menuCage.set_collision_layer_value(17, false)
	players[currentFront].followPos = players[currentFront].MAIN_VAL
	players[currentFront].storedX = 1
	players[currentFront].storedY = 0
	get_parent().bringToFront(players[currentFront])
	inMenu = false

func next():
	currentActive += 1
	if currentActive >= players.size():
		currentActive -= (players.size() - 1)
	if turnsSelected[turnsSelected.size()] != "":
		releasePlayer()
	

func back():
	var latestTurn: int
	for i: int in turnsSelected.size():
		if turnsSelected[i] != "":
			latestTurn = i
		
	turnsSelected 
