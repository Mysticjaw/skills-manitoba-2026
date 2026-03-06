extends StaticBody2D
#is it selected?
var selected: bool = false
#this is the tab it'll be switching to
var tab: Node
#this is... do we even use this? I swear I needed this
#for something but can't remember what for the life of me
var seen: bool

func _ready() -> void:
	#access the tab
	tab = get_tree().get_root().get_node(str(get_path()) + "/area")
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

#procees
func _process(_delta: float) -> void:
	#more of the same as in _ready()
	if !get_parent().visible:
		set_collision_layer_value(25, false)
		visible = false
	else:
		visible = true
		if selected:
			set_collision_layer_value(25, false)
		set_collision_layer_value(25, true)
		#if it's tab is selected then it's tab should be visible
		#if not it shouldn't be
	if get_parent().selectedNo == get_meta("tabValue") && visible:
		tab.visible = true
	else:
		tab.visible = false
		
# sets the selected tab to this one's
func selectTab():
	get_parent().selectedNo = get_meta("tabValue")
