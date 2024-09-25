extends Node2D

static var pswd:String = "1337"
static var max_saves_count:int = 30
var path: String = "res://Saves/"

#func _ready():
	#print_save_all_info(4)###debug
	#show_save_dir()
	#load_game(1)
	#delete_save(1)
	#print("******************")
	
func show_save_dir():
	var save_list = {}
	for i in max_saves_count:
		var save_path: String = "res://Saves/save"+str(i)+".save"
		if FileAccess.file_exists(save_path):
			save_list[i] = []
			save_list[i].append(get_info_from_save(i,"save_num",""))
			save_list[i].append(get_info_from_save(i,"save_name",""))
			save_list[i].append(get_info_from_save(i,"indicators","hp"))
			save_list[i].append(get_info_from_save(i,"indicators","coins"))
			save_list[i].append(get_info_from_save(i,"indicators","keys"))
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
	
func create_save(save_num:int,position: Vector2i,keys:int,hp:int,coins:int,doors: Dictionary,inventory:Array,save_name:String,entities:Dictionary):
	var save_dict = {
		"save_num": save_num,
		"save_name": save_name,
		"information": {
			"inventory": inventory,
			"doors": doors,
			"position": position,},
		"indicators": {
			"hp": hp,
			"coins": coins,
			"keys": keys,},
		"entities": entities
		}
	var save_path: String = "res://Saves/save"+str(save_num)+".save"
	#var save_game = FileAccess.open_encrypted_with_pass(save_path, FileAccess.WRITE, pswd)
	var save_game = FileAccess.open(save_path, FileAccess.WRITE)
	var json_string = JSON.stringify(save_dict)
	save_game.store_line(json_string)
	print("save_complite")
		
func get_info_from_save(save_num:int, save_info: String, save_info_name: String):
	var save_path: String = "res://Saves/save"+str(save_num)+".save"
	if not FileAccess.file_exists(save_path):
		return

	var save_game = FileAccess.open(save_path, FileAccess.READ)
	
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		var parse_result = json.parse_string(json_string)
		var node_data = json.get_data()
		var result = parse_result[save_info]
		var info
		match save_info:
			"indicators":
				return result[save_info_name]
			"information":
				return result[save_info_name]
			_:
				return result

func load_game(save_num:int):
	####игрок
	
	itemlist.inventory = get_info_from_save(save_num,"information","inventory")

	global.teleport(position_parser(get_info_from_save(save_num,"information","position")))
	global.player_indicators("hp", get_info_from_save(save_num,"indicators","hp"), "lock")
	global.player_indicators("coins", get_info_from_save(save_num,"indicators","coins"), "lock")
	global.player_indicators("keys", get_info_from_save(save_num,"indicators","keys"), "lock")
	global.get_global_scene("main").active_save = save_num
	
	####окружение
	
	OpenerList.opener_list = get_info_from_save(save_num,"information","doors")
	#print(get_info_from_save(save_num,"entities",""))
	Entities.load_entities(get_info_from_save(save_num,"entities",""))
	
	
	
	

func position_parser(line:String): ###Парсер инфы из сейва (Технический)
	var text = line
	var space = ", "
	text = text.lstrip("(").rstrip(")")
	var space2: int = text.find(space)
	var value1: String = text.substr(0,space2)
	space2 += 2
	var value2: String = text.substr(space2,len(text))
	return Vector2(int(value1),int(value2))
	
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
	
############################################################################################
####################№№№########ПОЛИГОН_ПОЛИГОН_ПОЛИГОН######################################
############################################################################################


		
