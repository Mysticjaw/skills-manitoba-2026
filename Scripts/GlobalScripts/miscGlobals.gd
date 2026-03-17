extends Node

var startPos: Vector2 = Vector2(0, 0)

var pad: bool = false

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
