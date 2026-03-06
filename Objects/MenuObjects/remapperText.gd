extends Label
#waow.
#amazing.


func _ready() -> void:	#sets the text initially
	updateText()

func _process(_delta: float) -> void:	#sets the text as it goes
	updateText()

#updates the text
func updateText():
	text = InputMap.action_get_events("key" + get_parent().get_meta("remapVal"))[0].as_text().to_upper()
