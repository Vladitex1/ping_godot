extends Control

var name2

func _ready():
	
	var name1 = $"../.."
	name2 = name1.name
	
	var back_load_but = $settings_menu/settings/Button_Back
	back_load_but.connect("button_up",load_back_button)
	
func load_back_button():
	global.get_global_scene("start_menu").select_menu("main")
