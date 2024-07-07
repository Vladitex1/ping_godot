extends Node2D

#func _ready():
var enemy: Node2D
var max:int 
var dict = {}
var node: Node2D
var spawn: bool = false

func _process(delta):
	var max_creatures = $".".get_child_count()
	if Input.is_action_just_released("debug2"):# and Input.is_action_just_pressed("attack"):
		var Spawn = load("res://Scenes/skeleton.tscn").instantiate()
		var mouse_pos = get_local_mouse_position()
		var nodepath = $"."
		node = Spawn
		node.position = mouse_pos
		spawn = true

		#$".".get_children()[max_creatures].get_children().state = DEATH
	for i in max_creatures:
		var path = $".".get_children()[i].get_path()
		var creature_name = str($".".get_children()[i].name)
		var creature_id = len(global.ememy_id_list)
		var my_object = $".".get_node_or_null(creature_name)
		var new_item = [creature_id, path, creature_name]
		dict[len(dict)] = new_item
		global.ememy_id_list[len(global.ememy_id_list)] = new_item
		if max_creatures>max:
			max = max_creatures
			if spawn:
				spawn = false
				add_child(node)
		if max_creatures<max:
			max = max_creatures
			
		#

	#enemyid(0,"SET",max)
	
	for i in max_creatures:
		var Player = $".".get_node(str($".".get_children()[0]))
		Player.dict1 = dict
		#print(Player.dict1)
		
	for i in len(dict):	
		enemyid(0,"SET",max) ##задаёт в лист плееру максимальное количество существ
		enemyid(i,"SET",i)
		
	#for b in len(global.ememy_id_list):
	#	print(str(enemyid(b,"GET",b)))
	
	dict = {}
	global.ememy_id_list = {}
	max = -1	

		#print("name1: "+str(enemy.name)+" = "+str(enemy.id)) 	
			#print("3: "+str(enemy.id)) 
	#print("__________________")		
func enemyid(id,GS,SET):
	match GS:
		"SET":
			$".".get_node(str($".".get_children()[id])).id = SET
		"GET":
			var ascds = $".".get_node(str($".".get_children()[id])).id
			return ascds
			
	
	
func get_random_num():
	var random_number_generator = RandomNumberGenerator.new()
	random_number_generator.randomize()
	var random_num = random_number_generator.randf()
	return random_num
