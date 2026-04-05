extends Node2D

@onready var battleStuff = preload("res://Objects/GameObjects/BattleStuff/battle_everything.tscn")

var battle: Node = null

#the amount of locations stored
var maxLocationsSize: int = 16
#it won't let me assign null to Vector2 variables so it's an alternative
const NULL_VAUE: Vector2 = Vector2(999992999.9, 999992999.9)
#to make sure that things don't start movng before they're supposed
#to by checking how many times a location has been added
var stepsTaken: int = -1
#how long into the period the primary player is (used for the followers)
var periodTime: float = 0
#is it moving
var moving: bool = false
#assigned as NULL_VALUE when not in use
#it's used to store locations until the _process() method happens
#not assigned a type so that null can be assigned
var thisLocation
#the actual stored past locations that the followers follow, 
#could also be followed by other things in the future
var pastLocations: Array[Vector2]
#which one are they following?
var players: Array[Node] = [null, null, null, null]
# goes slightly in front of you to better see what you're doing
var cameraPos: Vector2

var camera: Node

var attacking: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	#rezising the array to the max size and filling it with NULL_VALUEs
	pastLocations.resize(maxLocationsSize)
	for i in maxLocationsSize:
		pastLocations[i] = NULL_VAUE
	print(get_children())
	players.resize(get_children().size() - 1)
	print(players.size())
	cameraPos = MiscGlobals.startPos


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("trueBtnB") && !battle:
		startBattle()
	
	if thisLocation:	#if there's a location ready to be stored then start storing it
		newLocation(thisLocation)

func newLocation(location: Vector2) -> void:
	#remove the unessesery value, it's location now
	thisLocation = null
	#resize the array if it's changed size
	if pastLocations.size() != maxLocationsSize:
		#store the original size
		var originSize: int = pastLocations.size()
		pastLocations.resize(maxLocationsSize)
		#filling the new stuff
		for i in maxLocationsSize - originSize:
			pastLocations[i + originSize] = pastLocations[originSize]
		
	#actually making the new location
	stepsTaken += 1
	if stepsTaken <= 0:
		#if it's the first update then fill it
		for i in maxLocationsSize:
			pastLocations[i] = location
		
	#move everything down the line
	else:
		for i in maxLocationsSize - 1:
			pastLocations[maxLocationsSize - (i+1)] = pastLocations[maxLocationsSize - (i+2)]
		#add the new location to the end
		pastLocations[0] = location
		
	
func setPlayer(newPlayer: Node, value: int):
	players[value] = newPlayer

func startBattle():
	battle = battleStuff.instantiate()
	battle.global_position = players[0].global_position
	add_child(battle)	#the ready happens after this
	print(players.size())
	battle.prepareBattle(players)

func bringToFront(newFront: Node):
	var newFrontVal: int = -1
	for i in players.size():
		if players[i] == newFront:
			newFrontVal = i
	if newFrontVal == -1:
		print("YOU PUT IN A NON PLAYER OF MESSED UP STUPID")
	if newFrontVal >= players.size():
		print("HEYYYYYYYY THAT ISN'T A PLAYER SO YOU CAN'T BRING OT THE FRONT!!!")
		return
	var newFrontStorage: Node = players[newFrontVal]
	for i in newFrontVal:
		players[i + 1] = players[i]
	players[0] = newFrontStorage
