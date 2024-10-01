extends Node2D

var entities_num: int = 0

var entities = {}
			
func add_entities_in_list(creature_name: String,pos: Vector2,route: int,cur_check:int,hp:int):
	var data = [creature_name,pos,route,cur_check,hp]
	entities[entities_num] = data
	entities_num += 1
	print("регистрация юнита:", creature_name,": ",entities_num-1)
	return entities_num - 1

func update_entities(entity_num:int,info_id:int,edit):
	entities[entity_num][info_id] = edit

func get_info():
	print(entities)
	
func load_entities(data):
	var new_node: Object
	var main_node = global.get_global_scene("main")
	var node = main_node.get_child(1).get_child(1)
	for i in node.get_child_count():
		node.remove_child(node.get_child(0))
	entities = {}
	entities_num = 0	

	for i in data:
		match data[str(i)][0]:
			"skeleton":
				new_node = load("res://Scenes/mobs/skeleton_mob.tscn").instantiate()
		node.add_child(new_node)
		var new_creature = node.get_child(node.get_child_count()-1)
		new_creature.global_position = position_parser(data[str(i)][1])
		new_creature.route = data[str(i)][2]
		new_creature.current_checkpoint = data[str(i)][3]
		new_creature.health_value = data[str(i)][4]

	
func position_parser(line:String): ###Парсер инфы из сейва (Технический)
	var text = line
	var space = ", "
	text = text.lstrip("(").rstrip(")")
	var space2: int = text.find(space)
	var value1: String = text.substr(0,space2)
	space2 += 2
	var value2: String = text.substr(space2,len(text))
	return Vector2(int(value1),int(value2))

func del_entitie_from_list(num:int):
	entities.erase(num)
	print("запись удалена:", num)
