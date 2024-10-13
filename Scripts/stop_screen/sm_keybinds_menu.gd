extends Control

func _ready():
	var back_keybind_but = $settings_menu/settings/Button_Back
	back_keybind_but.connect("button_down",keybind_back_button)
	
func keybind_back_button():
	global.get_global_scene("start_menu").select_menu("settings")
