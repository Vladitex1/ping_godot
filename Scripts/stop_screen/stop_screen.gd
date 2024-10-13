extends CanvasLayer


@onready var control_module: Object = $control_module
@onready var back_plate: Object = $control_module/back_plate

var menu_state
var menu_dict = {}

var menu_open:bool = false
var console_open:bool = false
	
func _process(delta):
	if Input.is_action_just_released("special_back"):
		match menu_open:
			false:
				select_menu("main")
			true:
				exit_menu()
	elif Input.is_action_just_released("special_console"):
		match console_open:
			false:
				var console_node: Object = $control_module/main/first_line_stop_menu/VBoxContainer
				select_menu("console")
			true:
				exit_menu
			

	
func select_menu(state:String):
	match state:
		"hide":
			var menu = $".".get_child(0)
			for i in menu.get_child_count():
				var menu_node: String = "control_module/"+menu.get_child(i).name
				get_node(menu_node).visible = false
		_:
			menu_open = true
			global.buttons_lock = true	
			var menu = $".".get_child(0)
			for i in menu.get_child_count():
				if menu.get_child(i).name == state:
					back_plate.visible = true
					menu.get_child(i).visible = true
				else:
					menu.get_child(i).visible = false
		
func exit_menu():
	select_menu("hide")
	menu_open = false
	global.buttons_lock = false
	back_plate.visible = false

func get_confirm(queston: String,global_variable: String,function_name: String,value):# -> bool:
	$control_module/confirm_panel.visible = true
	$control_module/confirm_panel/VBoxContainer/Label.text = queston
	await $control_module/confirm_panel/VBoxContainer/HBoxContainer/YES.button_down
	if global.get_global_scene(global_variable).get_method_argument_count(function_name) == 1:
		global.get_global_scene(global_variable).call(function_name,value)
	$control_module/confirm_panel.visible = false
	if $control_module/confirm_panel/VBoxContainer/HBoxContainer/YES.button_down:
		return true
	return false
