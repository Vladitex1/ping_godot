extends Node2D

var enemy: Node2D
var enemy_max:int 
var dict = {}
var node: Node2D
var spawn: bool = false
var node_directory
var Player
var is_first_try: bool = true

func _process(_delta):
	if is_first_try:
		is_first_try = false
		global.hud_load()
	$"."
	if Input.is_action_just_released("debug2"):
		var node = $"."
		var max_creatures = $".".get_child_count()
		var Spawn = load("res://Scenes/mobs/skeleton_mob.tscn").instantiate()
		var mouse_pos = get_local_mouse_position()
		Spawn.position = mouse_pos
		spawn = true
		node.add_child(Spawn)


func _process(_delta):
	if is_first_try:
		is_first_try = false
		global.hud_load()
	
	var max_creatures = $".".get_child_count()
	if Input.is_action_just_released("debug2"):
		var max_creatures = $".".get_child_count()
		var Spawn = load("res://Scenes/mobs/skeleton_mob.tscn").instantiate()
		var mouse_pos = get_local_mouse_position()
		node = Spawn
		node.position = mouse_pos
		spawn = true
		node.add_child(Spawn)
		
		
	for i in max_creatures:
		var path = $".".get_children()[i].get_path()
		var creature_name = str($".".get_children()[i].name)
		var creature_id = len(global.ememy_id_list)
		var new_item = [creature_id, path, creature_name]
		
		dict[len(dict)] = new_item
		global.ememy_id_list[len(global.ememy_id_list)] = new_item
		if max_creatures > enemy_max:
			enemy_max = max_creatures
			if spawn:
				spawn = false
				add_child(node)
		if max_creatures < enemy_max:
			enemy_max = max_creatures
			

	node_directory = get_node("/root/main/Creatures")
	Player = node_directory.get_child(0)



	dict = {}
	global.ememy_id_list = {}
	enemy_max = -1	
			

