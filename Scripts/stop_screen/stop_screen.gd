extends CanvasLayer


@onready var control_module: Object = $control_module
@onready var back_plate: Object = $control_module/back_plate

var menu_state
var menu_dict = {}

var menu_open:bool = false


func _ready():
	set_menu_list()
	
func _process(delta):
	if Input.is_action_just_released("special_back"):
		match menu_open:
			false:
				select_menu(0)
			true:
				exit_menu()
		
	
func set_menu_list():
	var menu_start_num = 4
	var menu = $".".get_child(0)
	var menu_count = 0
	for i in menu.get_child_count():
		if i > menu_start_num-1:
			menu_dict[menu_count] = menu.get_child(i).name
			menu_count += 1
	
func select_menu(menu_state):
	if menu_state == -1:
		for i in menu_dict:
			var menu_node: String = "control_module/"+str(menu_dict[i])
			get_node(menu_node).visible = false
	else:
		menu_open = true
		global.buttons_lock = true	
		for i in menu_dict:
			if i == menu_state:
				var menu_node: String = "control_module/"+str(menu_dict[i])
				back_plate.get_child(1).text = menu_dict[i]
				back_plate.visible = true
				get_node(menu_node).visible = true
			else:
				var menu_node: String = "control_module/"+str(menu_dict[i])
				get_node(menu_node).visible = false
		
func exit_menu():
	select_menu(-1)
	menu_open = false
	global.buttons_lock = false
	back_plate.visible = false
