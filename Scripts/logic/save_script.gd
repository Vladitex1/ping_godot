extends Node2D

static var pswd:String = "1337"

#func _ready():
	#create_save(0,Vector2i(0,0))
	#create_save(2,Vector2i(2,1))
	#create_save(3,Vector2i(14,61))
	#show_save_dir()
	#load_game(1)
	#delete_save(1)
	#print("******************")
	
func show_save_dir():
	var save_list = {}
	for i in 10:
		var save_path: String = "res://Saves/save"+str(i)+".save"
		if FileAccess.file_exists(save_path):
			save_list[i] = []
			save_list[i].append(get_info_from_save(i,"position"))
			save_list[i].append(get_info_from_save(i,"save_num"))
	#print(save_list)
	#print("******************")
	return save_list
			
func delete_save(save_num:int):
	var save_path: String = "res://Saves/save"+str(save_num)+".save"
	if not FileAccess.file_exists(save_path):
		print("save_not_found")
		return
	else:
		DirAccess.remove_absolute(save_path)
		print("delete_complite")
	
func create_save(save_num:int,position: Vector2i,keys:int,hp:int,coins:int,doors: Dictionary,inventory:Array,save_name:String):
	var save_dict = {
		"save_num": save_num,
		"position": position,
		"keys": keys,
		"hp": hp,
		"сoins": coins,
		"doors": doors,
		"inventory": inventory,	
		"save_name": save_name,	
		}
	
	var save_path: String = "res://Saves/save"+str(save_num)+".save"
	#var save_game = FileAccess.open_encrypted_with_pass(save_path, FileAccess.WRITE, pswd)
	var save_game = FileAccess.open(save_path, FileAccess.WRITE)
	var json_string = JSON.stringify(save_dict)
	save_game.store_line(json_string)
	print("save_complite")
		
func get_info_from_save(save_num:int, save_info: String):
	var save_path: String = "res://Saves/save"+str(save_num)+".save"
	if not FileAccess.file_exists(save_path):
		return

	var save_game = FileAccess.open(save_path, FileAccess.READ)
	
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		var parse_result = json.parse_string(json_string)
		var node_data = json.get_data()
		var pos = parse_result[save_info]
		return pos

func load_game(save_num:int):
	print("load_game")
	var save_path: String = "res://Saves/save"+str(save_num)+".save"
	if not FileAccess.file_exists(save_path):
		print("файл не найден")
		return
		
	var save_game = FileAccess.open_encrypted_with_pass(save_path, FileAccess.WRITE, pswd)
	
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		var node_data = json.get_data()
		print(parse_result)
		print(node_data)




func config_save(res_id:int,flscr: bool):
	var save_dict = {
		"res_id": res_id,
		"flscr": flscr,
		"brightness": global.brightness,
		}
		

	var save_path: String = "res://Config/settings_config.save"
	#var save_game = FileAccess.open_encrypted_with_pass(save_path, FileAccess.WRITE, pswd)
	var save_game = FileAccess.open(save_path, FileAccess.WRITE)
	var json_string = JSON.stringify(save_dict)
	save_game.store_line(json_string)
	print("save_complite")
	
func config_load():
	var save_path: String = "res://Config/settings_config.save"

	if not FileAccess.file_exists(save_path):
		config_save(config.base_config["res_id"],false)
		config_load()
	var save_game = FileAccess.open(save_path, FileAccess.READ)
	var pos
	var res_id
	var brightness
	var flscr
	
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		var parse_result = json.parse_string(json_string)
		var node_data = json.get_data()
		res_id = parse_result["res_id"]
		brightness = parse_result["brightness"]
		flscr = parse_result["flscr"]
		
	config.BASE_RES_NUM = res_id ##resolution_slider
	global.brightness = brightness
	if flscr == true:
		DisplayServer.window_set_mode(3)
	else:
		DisplayServer.window_set_mode(0)
	
		
		
