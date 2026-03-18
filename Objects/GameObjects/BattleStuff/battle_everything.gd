extends Node2D

var playerWheel: Node

var parent: Node

var turningDirection: int = 0

var players: Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerWheel = get_node("playerWheel")
	parent = get_parent()
	parent.battle = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	playerWheel.rotation -= delta
	

func prepareBattle(playersNew: Array[Node]):
	players.resize(1)
	for i in playersNew.size():
		if playersNew[i].char == playersNew[i].SUPPORT_VAL:
			players[0] = playersNew[i]
			players[0].battleStart()
		else:
			players.resize(players.size() + 1)
			players[players.size() - 1] = playersNew[i]
		
	
