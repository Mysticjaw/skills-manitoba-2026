extends Node

var startPos: Vector2 = Vector2(0, 0)

var pad: bool = false


var activeText: String = ">"
var activeTextName: String = ""
var showingTextBox: bool = false

const dialogue: Array[Array] = [["haiiiiii!.!!!.2@3....... zdcmzd?!.11!?/!?!.1.1?????!!!!>>!>!...!!!/.!!!fy mame is [insert name here]>", "FIRST MESSAGE FROM ONE>", "FIRST MESSAGE FROM TWO>", "FIRST MESSAGE FROM THREE>", "SECOND MESSAGE FROM ZERO<"], [0, 1, 2, 3, 0]]
const names: Array[String] = ["ZERO", "ONE", "TWO", "THREE"]

var MoveNames: Array[Array] = [["FighterA", "FighterB"], ["MageA", "MageB"], ["TankA", "TankB"], ["something is wrong a", "something is wrong b"]]

var currentText = -1

const inputBuffer = 0.3

var healths: Array[int]
var maxHealths: Array[int]

var manas: Array[int]
var maxManas: Array[int]

func _ready() -> void:
	maxHealths = [100, 100, 100, 100]
	healths = [100, 100, 100, 100]
	maxManas = [100, 100, 100, 100]
	manas = [100, 100, 100, 100]


func removeFirst(arr: Array) -> Array:
	if arr.size():
		for i in arr.size() - 1:
			arr[i] = arr[i + 1]
		arr.resize(arr.size() - 1)
	return arr

func fillUpTo(arr: Array, filler, newSize: int) -> Array:
	for i in newSize:
		if i + 1 > arr.size():
			arr.resize(i + 1)
			arr[i] = filler
		
	return arr
	
func fillUpToNulls(arr: Array, filler, newSize: int) -> Array:
	for i in newSize:
		if i + 1 > arr.size():
			arr.resize(i + 1)
		if !arr[i]:
			arr[i] = filler
		
	return arr

func addHealthTo(recipeint: int, damage: int, bounded: bool):
	healths[recipeint] += damage
	if bounded:
		if healths[recipeint] > maxHealths[recipeint]:
			healths[recipeint] = maxHealths[recipeint]
		elif healths[recipeint] <= 0:
			healths[recipeint] = 1
		
	

func setHealthTo(recipeint: int, newHealth: int, bounded: bool):
	healths[recipeint] += newHealth
	if bounded:
		if healths[recipeint] > maxHealths[recipeint]:
			healths[recipeint] = maxHealths[recipeint]
		elif healths[recipeint] <= 0:
			healths[recipeint] = 1
		
	

func nextBox():
	match activeText[activeText.length() - 1]:
		">":
			showingTextBox = true
			currentText += 1
			activeText = dialogue[0][currentText]
			activeTextName = names[dialogue[1][currentText]]
		"<":
			showingTextBox = false
			activeText = ">"
