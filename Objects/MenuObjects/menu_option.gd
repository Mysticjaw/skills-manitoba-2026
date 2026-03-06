extends StaticBody2D
#is it selected?
var selected: bool = false

#redy
func _ready() -> void:
	checkVisibility()

# that's not... the thorn ring, is it?
func _process(_delta: float) -> void:
	checkVisibility()

func checkVisibility():
	#if you can't see it it shouldn't be active
	#(and visible is for something in the selecter)
	if !get_parent().visible:
		set_collision_layer_value(25, false)
		visible = false
	else:
		#vise versa
		#(and if it's selected you don't want to be hitting it)
		visible = true
		if selected:
			set_collision_layer_value(25, false)
		else:
			set_collision_layer_value(25, true)
