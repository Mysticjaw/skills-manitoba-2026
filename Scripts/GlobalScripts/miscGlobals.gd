extends Node

var startPos: Vector2 = Vector2(0, 0)

var pad: bool = false

var healths: Array[int]
var maxHealths: Array[int]

var manas: Array[int]
var maxManas: Array[int]

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
		
	
