extends Node2D

@onready var parent: Node = get_parent()
@onready var cam: Node = get_node("camera")

var slidingTo: Vector2
var slidingTime: float
var nextMode: int = 1

const SLIDING_VAL: int = -1
const NOTHING_VAL: int = 0
const FOLLOW_VAL: int = 1
const FOLLOW_UNSMOOTHENED_ADDITION: int = 2

const REALLY_FAR_AWAY = 10000000

const FOLLOW_SPEED: float = 0.2

const STOPPED_AREA: int = 50

var followMode: int = FOLLOW_VAL

var cameraBoundObjects: Array[Node2D]

var primaryHad: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = MiscGlobals.startPos
	cameraBoundObjects.resize(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if followMode > NOTHING_VAL:
		if followMode >= FOLLOW_UNSMOOTHENED_ADDITION:
			var looping = true
			for i in followMode + 1 - FOLLOW_UNSMOOTHENED_ADDITION:
				if parent.players.size() >= followMode + 1 - (FOLLOW_UNSMOOTHENED_ADDITION + i) && looping:
					if parent.players[followMode + 1 - (FOLLOW_UNSMOOTHENED_ADDITION + i)] != null:
						global_position = parent.players[followMode - FOLLOW_UNSMOOTHENED_ADDITION].global_position
						get_node("cameraArea").global_position = parent.players[0].global_position
						looping = false
					
				
			
		else: 
			global_position.x = parent.cameraPos.x - (parent.cameraPos.x - global_position.x) * pow(FOLLOW_SPEED, delta)
			global_position.y = parent.cameraPos.y - (parent.cameraPos.y - global_position.y) * pow(FOLLOW_SPEED, delta)
			get_node("cameraArea").global_position = parent.players[0].global_position
		
	elif followMode >= SLIDING_VAL:
			if slidingTime - delta <= 0:
				followMode = nextMode
				global_position = slidingTo
			else:
				global_position += ((slidingTo - global_position) * delta / slidingTime)
				slidingTime -= delta
			
		
	

func slideTo(destination: Vector2, time: float, newMode: int):
	slidingTo = destination
	slidingTime = time
	nextMode = newMode
	followMode = SLIDING_VAL


func _on_camera_area_body_exited(body: Node2D) -> void:
	
	var looping: bool = true
	for i in cameraBoundObjects.size():
		if looping:
			if body == cameraBoundObjects[i]:
				for j in cameraBoundObjects.size() - (i + 1):
					cameraBoundObjects[j + i] = cameraBoundObjects [j + i + 1]
				cameraBoundObjects.resize(cameraBoundObjects.size() - 1)
				looping = false
			
		
	if body.get_meta("primary"):
		primaryHad = false
		print(cameraBoundObjects.size())
		print(cameraBoundObjects)
		for i in cameraBoundObjects.size():
			if cameraBoundObjects[i].get_meta("primary"):
				primaryHad = true
				print("AAAAA")
			
		
	if cameraBoundObjects.size() != 0:
		if abs(body.left - cam.limit_left) < 1:
			cam.limit_left = cameraBoundObjects[0].left
			for i in cameraBoundObjects.size() - 1:
				if cameraBoundObjects[i + 1].left > cam.limit_left:
					cam.limit_left = cameraBoundObjects[i + 1].left
				
			
		if abs(body.top - cam.limit_top) < 1:
			cam.limit_top = cameraBoundObjects[0].top
			for i in cameraBoundObjects.size() - 1:
				if cameraBoundObjects[i + 1].top > cam.limit_top:
					cam.limit_top = cameraBoundObjects[i + 1].top
				
			
		if abs(body.right - cam.limit_right) < 1:
			cam.limit_right = cameraBoundObjects[0].right
			for i in cameraBoundObjects.size() - 1:
				if cameraBoundObjects[i + 1].right < cam.limit_right:
					cam.limit_right = cameraBoundObjects[i + 1].right
				
			
		
		if abs(body.bottom - cam.limit_bottom) < 1:
			cam.limit_bottom = cameraBoundObjects[0].bottom
			for i in cameraBoundObjects.size() - 1:
				if cameraBoundObjects[i + 1].bottom < cam.limit_bottom:
					cam.limit_bottom = cameraBoundObjects[i + 1].bottom
				
			
		
	else:
		cam.limit_left = -REALLY_FAR_AWAY
		cam.limit_top = -REALLY_FAR_AWAY
		cam.limit_right = REALLY_FAR_AWAY
		cam.limit_bottom = REALLY_FAR_AWAY
	


func _on_camera_area_body_entered(body: Node2D) -> void:
	if !primaryHad || !body.get_meta("primary"):
		if body.get_meta("primary"):
			primaryHad = true
		if body.left > cam.limit_left:
			cam.limit_left = body.left
		if body.right < cam.limit_right:
			cam.limit_right = body.right
		if body.top > cam.limit_top:
			cam.limit_top = body.top
		if body.bottom < cam.limit_bottom:
			cam.limit_bottom = body.bottom
		
	cameraBoundObjects.resize(cameraBoundObjects.size() + 1)
	cameraBoundObjects[cameraBoundObjects.size() - 1] = body

func followPlayer():
	followMode = FOLLOW_VAL
