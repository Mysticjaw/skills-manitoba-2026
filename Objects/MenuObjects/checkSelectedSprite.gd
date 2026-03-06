extends AnimatedSprite2D
#for changing the way it looks based on if it's parent is selected

func _ready() -> void:	#not really nesessary, but just to avoid any weird switching
	animation = "unselected"


func _process(_delta: float) -> void:
	if(get_parent().selected):	#if selected then animation is selected
		animation = "selected"
	else:	#if not selected then animation is not selected
		animation = "unselected"
	
	
