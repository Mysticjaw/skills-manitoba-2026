extends StaticBody2D
#TO LOCK THE CAMERA TO THE CENTER MAKE THE SCALE FOR THAT AXIS REVERSED
var left: float
var top: float
var right: float
var bottom: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	left = global_position.x
	top = global_position.y
	right = global_position.x + scale.x
	bottom = global_position.y + scale.y
