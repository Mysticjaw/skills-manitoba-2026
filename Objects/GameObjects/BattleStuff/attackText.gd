extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var papaparent := get_parent().get_parent().get_parent()
	if papaparent.player != null && papaparent.player.charVal != papaparent.player.SUPPORT_VAL:
		var value: int = get_meta("value")
		match value:
			0:
				if papaparent.player == papaparent.get_parent().get_parent().players[papaparent.get_parent().get_parent().currentActive]:
					get_parent().visible = true
				else:
					get_parent().visible = false
				if papaparent.player == papaparent.get_parent().get_parent().players[papaparent.get_parent().get_parent().currentFront]:
					text = "ATTACK"
				else:
					text = "ITEM"
				#print(value)
			1: 
				text = MiscGlobals.MoveNames[papaparent.player.charVal][0]
			2:
				text = MiscGlobals.MoveNames[papaparent.player.charVal][1]
			3:
				if papaparent.player == papaparent.get_parent().get_parent().players[papaparent.get_parent().get_parent().currentFront]:
					text = "SWITCH"
				else:
					text = "BACK"
				#print(value)
			
		
	
