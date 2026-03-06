extends Control


		#These are the things related to the menu itself:

#which tab is selected
var selectedNo: int = 0

#hide it to start
func _ready() -> void:
	hide()

		#these are the things related to remapping


# what action if any is being remapped
#(not assigned type so that null can be assigned)
var currentRemapK = null
#so that it can bring back the selecter when
#ramapping is done
var selecterKeep: Node

#the different sticks and weather they're enabled or not
const JOYS: Array[String] = ["L", "R", "D"]
var joyActives: Array[bool] = [true, true, true]
#to make asssigning all the directions in a way easier
const DIRECTIONS: Array[String] = ["Up", "Down", "Left", "Right"]
#it's process
#we know what process is
func _process(_delta: float) -> void:
	if get_parent().visible:	#to stop it from running when the menu isn't open
		for i in JOYS.size():	#look through the different sticks
			#if the joy's activeness and intended activness differ
			if Settings.settingsValues["joy" + JOYS[i]] != joyActives[i]:
				if !joyActives[i]:	#if it's supposed to be active
					for j in DIRECTIONS.size():	#then activate all the parts of it
						#store the part that must be toggled
						var storedEvent: InputEvent = (InputMap.action_get_events("joy" + JOYS[i] + DIRECTIONS[j]))[0]
						#add the stored event
						InputMap.action_add_event("true" + DIRECTIONS[j], storedEvent)
					
				
				else:	#if not
					print("")	#then deactivate the parts
					for j in DIRECTIONS.size():
						#store the part that must be toggled
						var storedEvent: InputEvent = (InputMap.action_get_events("joy" + JOYS[i] + DIRECTIONS[j]))[0]
						#add the stored event
						InputMap.action_erase_event("true" + DIRECTIONS[j], storedEvent)
					
				
			#it's been toggled, so update the joyactive
			joyActives[i] = !joyActives[i]
		
	
#if any input comes in
func _input(event):
	#if it's something on a controller:
	if Input.is_action_pressed("padAny"):
		MiscGlobals.pad = true
	#if it's instead something on a keyboard:
	elif event is InputEventKey && event.pressed:
		MiscGlobals.pad = false
		if currentRemapK != null:	#if remapping is happening
			#store the old event to remove it from the actions
			var removeInput: InputEvent = InputMap.action_get_events("key" + currentRemapK)[0]
			#remove the old event from the key and true versions of the input
			InputMap.action_erase_event("key" + currentRemapK, removeInput)
			InputMap.action_erase_event("true" + currentRemapK, removeInput)
			#add the new input to the key and true versions of the input
			InputMap.action_add_event("key" + currentRemapK, event)
			InputMap.action_add_event("true" + currentRemapK, event)
			#bring back the selecter
			selecterKeep.show()
			#clear the input being remapped
			currentRemapK = null
			#reset the pause settings
			get_tree().get_root().process_mode = Node.PROCESS_MODE_PAUSABLE
			get_tree().get_root().get_children()[0].process_mode = Node.PROCESS_MODE_INHERIT
		
	
#start remapping a key (keyname)
#disable the selecter while this happens
func remapKey(keyName: String, selecter: Node):
	#so that _process() (or in this case, _input()) happens
	get_tree().get_root().process_mode = Node.PROCESS_MODE_ALWAYS
	#but we don't want the game unpausing
	get_tree().get_root().get_children()[0].process_mode = Node.PROCESS_MODE_PAUSABLE
	#set currentremapK to the current key to remap
	currentRemapK = keyName
	#make sure the selecter is stored so that it can be brought back later and then hide it
	selecterKeep = selecter
	selecterKeep.hide()

func setKeymapsFromFile() -> void:
	#if we set up a file to store the settings this should
	#set up the keymaps on opening
	pass
