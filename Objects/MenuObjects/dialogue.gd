extends Label

var timeSinceShow: float = 0

var showingText = true

const SCROLL_SPEED = 0.01

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible_characters = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if showingText:
		timeSinceShow += delta
		while timeSinceShow > SCROLL_SPEED:
			visible_characters += 1
			timeSinceShow -= SCROLL_SPEED	
			if visible_characters >= text.length():
				print("ALL SHOWN")
				showingText = false
				timeSinceShow = 0
				
	
