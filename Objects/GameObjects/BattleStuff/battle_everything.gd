extends Node2D

var playerWheel: Node



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerWheel = get_node("playerWheel")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
