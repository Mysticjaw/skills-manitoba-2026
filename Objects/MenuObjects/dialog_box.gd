extends Control

@onready var text: Node = get_node("text")
@onready var textName: Node = get_node("title")

var timeSinceShow: float = 0

var revealingText = true

const SLOW_CHARACTERS: Array[String] = ['.', '?', '!']
const MED_CHARACTERS: Array[String] = [',', '~']
var quoteUsed: bool = false
const SLOW_CHAR_SPEED = 0.05
const MED_CHAR_SPEED = 0.2
const SKIP_CHAR_SPEED = 5

const SCROLL_SPEED: float = 0.01
const MAX_TITLE_SIZE: int = 243
const MAX_FONT_SIZE: int = 29

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text.visible_characters = 0
	text.text = MiscGlobals.activeText
	textName.text = MiscGlobals.activeTextName
	setTextNameSize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if MiscGlobals.showingTextBox:
		visible = true
		if get_node("text").text != MiscGlobals.activeText || get_node("title").text != MiscGlobals.activeTextName:
			get_node("text").visible_characters = 0
			revealingText = true
			get_node("text").text = MiscGlobals.activeText
			get_node("title").text = MiscGlobals.activeTextName
		var scrollMult: float = setSpeed()
		if Input.is_action_pressed("trueBtnY"):
			scrollMult = SKIP_CHAR_SPEED
			if get_node("text").visible_characters >= get_node("text").text.length() - 1:
				MiscGlobals.nextBox()
		if Input.is_action_just_pressed("trueBtnA"):
			if get_node("text").visible_characters >= get_node("text").text.length() - 1:
				MiscGlobals.nextBox()
			else:
				get_node("text").visible_characters = get_node("text").text.length() - 1
		if revealingText:
			timeSinceShow += delta * scrollMult
			while timeSinceShow > SCROLL_SPEED && get_node("text").visible_characters < get_node("text").text.length() - 1:
				get_node("text").visible_characters += 1
				timeSinceShow -= SCROLL_SPEED	
			if get_node("text").visible_characters >= get_node("text").text.length() - 1:
				print("ALL SHOWN")
				revealingText = false
				timeSinceShow = 0 
				
			
		
	else:
		visible = false
	

func setTextNameSize() -> void:
	textName.label_settings.font_size = MAX_FONT_SIZE
	print(textName.size.x)
	print(MAX_TITLE_SIZE)
	while textName.size.x > MAX_TITLE_SIZE:
		print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
		textName.label_settings.font_size -= 1
	
func setSpeed() -> float:
	var last = text.text[text.visible_characters - 1]
	var next = ""
	if text.visible_characters != text.text.length():
		next = text.text[text.visible_characters]
	var punctuation: bool = false
	for i in SLOW_CHARACTERS:
		if i == last:
			punctuation = !punctuation
		if i == next:
			punctuation = !punctuation
		
	if last == SLOW_CHARACTERS[0]:
		punctuation = true
	if punctuation:
		return SLOW_CHAR_SPEED
	if last == '"':
		quoteUsed = !quoteUsed
		if quoteUsed:
			return 0.05
	return 1
