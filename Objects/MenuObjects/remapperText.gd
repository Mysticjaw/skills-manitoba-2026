extends Label
#waow.
#amazing.

const MAX_FONT_SIZE: int = 16
var MAX_TEXT_SIZE: int = 33


func _ready() -> void:	#sets the text initially
	updateText()

func _process(_delta: float) -> void:	#sets the text as it goes
	updateText()

#updates the text
func updateText():
	text = InputMap.action_get_events("key" + get_parent().get_meta("remapVal"))[0].as_text().to_upper()
	setTextSize()



func setTextSize() -> void:
	label_settings.font_size = MAX_FONT_SIZE
	#print(size.x)
	#print(MAX_TEXT_SIZE)
	
	if size.x > MAX_TEXT_SIZE:
		#print(get_parent())
		#print("PAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
		label_settings.font_size = 10
