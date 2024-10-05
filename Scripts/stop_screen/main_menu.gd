extends Control

var name2

func _ready():
	var name1 = $"../.."
	name2 = name1.name
	var continue_but = $first_line_stop_menu/VBoxContainer/Button_Continue
	continue_but.connect("button_up",continue_button)
	var settings_but = $first_line_stop_menu/VBoxContainer/Button_Settings
	settings_but.connect("button_up",settings_button)
	var load_but = $first_line_stop_menu/VBoxContainer/Button_Load
	load_but.connect("button_up",load_button)
	var quit_but = $first_line_stop_menu/VBoxContainer/Button_Quit
	quit_but.connect("button_up",quit_button)
	
func continue_button():
	global.get_global_scene(name2).exit_menu()
	
func load_button():
	global.get_global_scene(name2).select_menu(1)
	
func settings_button():
	global.get_global_scene(name2).select_menu(2)

func quit_button():
	get_tree().quit()
