extends CanvasLayer

@onready var main_menu = $"."
var console_visible: bool = true

func _ready():
	####main_menu####
	var continue_but = $first_line_stop_menu/main/Button_Continue
	continue_but.connect("button_up",continue_button)
	var settings_but = $first_line_stop_menu/main/Button_Settings
	settings_but.connect("button_up",settings_button)
	var quit_but = $first_line_stop_menu/main/Button_Quit
	quit_but.connect("button_up",quit_button)

func _process(_delta):
	for i in get_tree().root.get_child_count():
		print(get_tree().root.get_child(i).name)
	
	print("____")
	
	if Input.is_action_just_released("special_back"):
		global.del_scene("settings")

		
func continue_button():
	print("консоль выкл")
	console_visible = true
	global.del_scene("main_menu")
	global.add_scene("main1")
	
func settings_button():
	global.add_scene("settings")

func quit_button():
	get_tree().quit()

