extends Control

var name_of_root_scene: String = "main"
var teleport_toggle: bool = false
@onready var node: Object = $"."
@onready var console_line: Object = $"LineEdit"

func _process(delta):
	if Input.is_action_just_released("enter") and node.visible == true:
		var command = str(console_line.get_text())
		var text = console_text_parse(command)
		console_line.set_text(text)
		await get_tree().create_timer(2).timeout
		console_line.set_text("")


func teleport(x,y):
	var vector
	if x == "spawn":
		vector = Vector2(250,250)
	else:
		vector = Vector2(int(x),int(y))
	var node = $"/root/main".get_child(1).get_child(0)
	node.player.set_global_position(vector)
	
func item(value,delta):
	delta = int(delta)
	value = str(value)
	global.player_indicators(value,delta,"set")

func loot(value1,value2):
	var itemid: int
	for i in itemlist.itemlist.size() - 1 :
		if itemlist.itemlist[i][2] == str(value1):
			itemid = i
	var spawn = load("res://Scenes/objects/dynamic_loot.tscn").instantiate()
	spawn.position = get_global_mouse_position()
	var node = get_tree().root.get_children()
	for i in node.size():
		#print(node[i].name)
		if node[i].name == name_of_root_scene:
			var drop_node = node[i].get_child(3)
			spawn.item = itemid
			drop_node.add_child(spawn)			

func mob(value1,value2):
	var spawn
	var drop_node = global.get_global_scene("main").get_child(1).get_child(1)
	match value1:
		"skeleton":
			spawn = load("res://Scenes/mobs/skeleton_mob.tscn").instantiate()
	match value2:
		"cursor":
			spawn.global_position = global.mouse_pos
		_:
			spawn.global_position = position_parser(value2)
			print(position_parser(value2))
	drop_node.add_child(spawn)
	
var pos	
func input(command,value1,value2,value3):
	var text 
	match command:
		"hello":
			text = str(OS.get_name())
			if OS.get_name() == "macOS":
				text = str("Hello ", OS.get_environment("USER"),"!")
			else: 
				text = str("Hello ", OS.get_environment("USERNAME"),"!")
		"teleport":
			teleport(value1,value2)
			text = str("teleported to: ",value1," ",value2)
		"item":
			item(value1,value2)
			text = str("give item: ",value1," in count = ",value2)
		"spawn":
			match value1:
				"loot":
					loot(value2,value3)
				"mob":
					mob(value2,value3)

			text = str("spawned ",value1,"name: ",value2)
		_:
			text = "input_error"
	return text

func console_text_parse(text : String):
	var command: String
	var value1: String
	var value2: String
	var value3: String
	var space = " "
	var firstSpace: int = text.find(space)
	var secondSpace: int = text.find(space,firstSpace+1)
	var thirdSpace: int = text.find(space,secondSpace+1)
	
	var error_mode = len(text)
	if firstSpace == -1 or secondSpace == -1 or thirdSpace == -1:
		error_mode = true
		
	if !error_mode:
		value1 = text.substr(firstSpace+1,secondSpace - firstSpace-1)
		value2 = text.substr(secondSpace+1,thirdSpace - secondSpace-1)
		value3 = text.substr(thirdSpace+1,len(text))
	else:
		value1 = text.substr(firstSpace+1,len(text))
		value2 = ""
		
	if firstSpace == -1:
		command = text
	else:
		command = text.substr(0, firstSpace)

	print(error_mode)
	var text2
	if value1 == null:
		text2 = "input_error"
		return text2
	print(value1,value2,value3)
	print(value1,":")
	return input(str(command),value1,value2,value3)

func position_parser(line:String): ###Парсер инфы из сейва (Технический)
	var text:String = line
	var space: String = " "
	var space2: int = text.find(space)
	var value1: String = text.substr(0,space2)
	space2 += 2
	var value2: String = text.substr(space2,len(text))
	return Vector2(int(value1),int(value2))
