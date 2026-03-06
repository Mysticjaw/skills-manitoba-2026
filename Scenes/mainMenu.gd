extends PanelContainer


#is the game able to be paused or unpaused
var pausable: bool = true

#the things buttons can do when pressed:
func menuAction(bValue: int, selecter: Node):
	match bValue:	#I love switch statements
		0:
			#in case I forgot to assign the value
			print("YOU FORGOT TO ASSIGN THE BUTTON VALUE TO " + str(selecter.current))
		1:
			#start the game
			get_tree().change_scene_to_file("res://Scenes/Areas/world.tscn")
		2:
			#continue button, not in use due to having no save system,
			#we'll probably grey this one out in the final version
			print("continue")
		3:
			#show the settings menu and hide these buttons
			get_node("settingsMenu").show()
			get_node("menuButtons").hide()
			# so that the selecter isn't floating in space, because doing that breaks things
			#(it'll just stay in it's original position until it sees something below it)
			get_node("menuSelecter").instantSelect(get_node("settingsMenu/btnReturn"))
		4:
			#just leave the game
			get_tree().quit()
		5:
			#the opposite of value 3
			get_node("menuButtons").show()
			get_node("settingsMenu").hide()
			get_node("menuSelecter").instantSelect(get_node("menuButtons/btnOptions"))
		6:
			#select a tab
			selecter.current.selectTab()
		7: 
			#set a boolien setting via one of the checkboxes
			Settings.setSetting(selecter.current.get_meta("valueName"), !Settings.settingsValues[selecter.current.get_meta("valueName")])
		8:
			#remap a control
			get_node("settingsMenu").remapKey(selecter.current.get_meta("remapVal"), selecter)
	
	
#restore the menus (not the pausemenu's tab because it's prolly more
#convenient to the player if it doesn't
#full is if it's also restoring the player to it's original posiiton
func restore(full: bool):
	menuAction(5, get_node("menuSelecter"))
	if full:
		get_node("menuSelecter").reset()
	
