extends Node2D

var name_of_root_scene: String = "main"
var teleport_toggle: bool = false

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

func loot(value1):
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

			

func mob(value1):
	var spawn
	match value1:
		"skeleton":
			spawn = load("res://Scenes/mobs/skeleton_mob.tscn").instantiate()
	spawn.position = get_global_mouse_position()
	var node = get_tree().root.get_children()
	for i in node.size():
		if node[i].name == name_of_root_scene:
			var drop_node = node[i].get_child(1)
			drop_node.add_child(spawn)
	
func input(command,value1,value2):
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
					loot(value2)
				"mob":
					mob(value2)
			text = str("spawned ",value1,"name: ",value2)
		_:
			text = "input_error"
	return text
