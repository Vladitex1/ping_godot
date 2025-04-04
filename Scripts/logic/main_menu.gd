extends CanvasLayer


@onready var control_module: Object = $control_module
@onready var back_plate: Object = $control_module/back_plate

var menu_state
var menu_dict = {}

var menu_open:bool = false
var console_open:bool = false

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

func get_confirm(queston: String,global_variable: String,function_name: String,value):# -> bool:
	pass
	#print("result: ", result)
func window_reset(res):#########################################################
	var scaled = config.resolution_list[res][2]
	var resolution = Vector2(config.resolution_list[res][0],config.resolution_list[res][1])
	var positioned = Vector2(config.resolution_list[res][3],config.resolution_list[res][4])
	DisplayServer.window_set_size(resolution)
	get_viewport().size = resolution
	control_module.scale = Vector2(scaled,scaled)
	control_module.position = positioned
