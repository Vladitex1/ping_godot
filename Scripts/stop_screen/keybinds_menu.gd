extends Control

var name2

func _ready():
	var back_keybind_but = $settings_menu/settings/Button_Back
	back_keybind_but.connect("button_down",keybind_back_button)
	
func keybind_back_button():
	global.get_global_scene("stop_screen").select_menu("settings")
