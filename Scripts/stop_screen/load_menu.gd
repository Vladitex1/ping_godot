extends Control

func _ready():
	var back_load_but = $settings_menu/settings/Button_Back
	back_load_but.connect("button_up",load_back_button)
	
func load_back_button():
	global.get_global_scene("stop_screen").select_menu(0)
