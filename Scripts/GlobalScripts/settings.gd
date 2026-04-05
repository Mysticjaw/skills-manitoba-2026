extends Node	#for storing settings
#the constants to do with settings:
const MAX_VOLUME: int = 10
const MIN_VOLUME: int = 0
#the main bulk of the settings,
#(and prolly easy to make into a file if I knew how to do that in godot)
var settingsValues: Dictionary = {	#more will be added eventually
	"joyL": true,	#if the different controllerSticks are on
	"joyR": true,
	"joyD": true,
	"mute": false	#muted
}

#set a setting to a value
func setSetting(valName: String, value):
	settingsValues[valName] = value
	if !settingsValues["joyL"] && !settingsValues["joyR"] && !settingsValues["joyD"]:
		print("all off")
		if valName == "joyD":
			settingsValues["joyL"] = true
			print("joyL is true")
			print(settingsValues["joyL"])
		else:
			settingsValues["joyD"] = true
			print("joyD is true")
