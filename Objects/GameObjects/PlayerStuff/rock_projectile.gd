extends StaticBody2D

var timeLeft: float = 20
var coolDownLeft: float = 0.2

var direction: Vector2 = Vector2(1, 0)

const SPEED: int = 700

var player: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rotation = ((1 - direction.x) * PI / 2) - ((abs(direction.y) - direction.y) * PI / 2)
	get_node("sprite").play("rock")
	get_node("sprite").frame = rng.randf_range(0, 3)
	global_position = player.global_position + (direction * 50)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timeLeft -= delta
	coolDownLeft -= delta
	position.x += SPEED * delta * direction.x
	position.y += SPEED * delta * direction.y
	if coolDownLeft <= 0:
		coolDownLeft = 999
		player.midAttack = false
	if timeLeft <= 0:
		queue_free()
