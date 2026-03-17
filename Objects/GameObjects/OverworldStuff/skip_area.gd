extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if abs(body.global_position.x - global_position.x) >= scale.x:
		if body.global_position.x - global_position.x < 0:
			body.global_position.x += scale.x * 2
		else:
			body.global_position.x -= scale.x * 2
		
	if abs(body.global_position.y - global_position.y) >= scale.y:
		if body.global_position.y - global_position.y < 0:
			body.global_position.y += scale.y * 2
		else:
			body.global_position.y -= scale.y * 2
		
	
