extends Control

#is the game able to be paused or unpaused
var pausable: bool = true

#hide imidiately
func _ready() -> void:
	hide()


#pausing the game
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("truePause") && pausable:
		get_tree().paused = !get_tree().paused
		#if it's visible then restore the selecter and menus to their original states
		if visible:
			restore(true)
	visible = get_tree().paused
	

#the code behind the buttons
func menuAction(bValue: int, selecter: Node):
	match bValue:
		0:
			#in case I forgot to assign the value
			print("YOU FORGOT TO ASSIGN THE BUTTON VALUE TO " + str(selecter.current))
		1:	#unpause the game
			print("resume")
			get_tree().paused = false
		2:	#return to main menu
			get_tree().paused = false
			get_tree().change_scene_to_file("res://Scenes/Menu.tscn")
		3:	#open the options menu
			get_node("settingsMenu").show()
			get_node("menuButtons").hide()
			#to avoid the selecter just floating in space:
			get_node("menuSelecter").instantSelect(get_node("settingsMenu/btnReturn"))
		4:	#quit the game
			get_tree().quit()
		5:	#return to main section of pause menu
			get_node("menuButtons").show()
			get_node("settingsMenu").hide()
			#to avoid the selecter just floating in space:
			get_node("menuSelecter").instantSelect(get_node("menuButtons/btnOptions"))
		6:	#select the tab
			selecter.current.selectTab()
		7:	#toggle a boolean setting 
			Settings.setSetting(selecter.current.get_meta("valueName"), !Settings.settingsValues[selecter.current.get_meta("valueName")])
		8:	#remap a control
			get_node("settingsMenu").remapKey(selecter.current.get_meta("remapVal"), selecter)

#restore the menus (not the pausemenu's tab because it's prolly more
#convenient to the player if it doesn't
#full is if it's also restoring the player to it's original posiiton
func restore(full: bool):
	#close the settings menu
	if pausable:
		#the close settings one
		menuAction(5, get_node("menuSelecter"))
		if full:	#resets the selecter
			get_node("menuSelecter").reset()
		
	
	
