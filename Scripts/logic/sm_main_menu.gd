extends Control

func _ready():
	connect_buttons()

func connect_buttons():
	var button_num:int = 0
	var container: Object = $first_line_stop_menu/VBoxContainer

	var continue_but = container.get_child(button_num)
	continue_but.connect("button_up",continue_button)
	
	button_num+=1
	var new_game_but = container.get_child(button_num)
	new_game_but.connect("button_up",newgame_button)
	
	button_num+=1
	var load_but = container.get_child(button_num)
	load_but.connect("button_up",load_button)
	
	button_num+=1
	var settings_but = container.get_child(button_num)
	settings_but.connect("button_up",settings_button)
	
	button_num+=1
	var quit_but = container.get_child(button_num)
	quit_but.connect("button_up",quit_button)
	
func continue_button():
	global.del_scene("start_menu")
	global.add_scene("main1")
	
	
func newgame_button():
	#print("ПУК-пук")
	global.get_global_scene("start_menu").select_menu("new_game")
	
func load_button():
	global.get_global_scene("start_menu").select_menu("load")

func settings_button():
	global.get_global_scene("start_menu").select_menu("settings")

func quit_button():
	get_tree().quit()
