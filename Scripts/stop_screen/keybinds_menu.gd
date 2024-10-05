extends Control

var name2

func _ready():
	var name1 = $"../.."
	name2 = name1.name
	var back_keybind_but = $settings_menu/settings/Button_Back
	back_keybind_but.connect("button_down",keybind_back_button)
	
func keybind_back_button():
	global.get_global_scene(name2).select_menu(2)
