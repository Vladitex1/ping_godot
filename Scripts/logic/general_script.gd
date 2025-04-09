extends Node2D

@export var profile_name: String
var lvl_start_position: Vector2 = Vector2(263,279)
var start = false

func _ready():
	SaveScript.config_load()
func _process(delta) -> void:
	if !start:
		start = true
		global.buttons_lock = false
		
		global.add_scene("stop_screen/stop_screen")
		global.add_scene("hud")
		global.add_scene("inventory/inventory")
		global.add_scene("shop/shop")
		
		global.visible_scene("shop",false)


func debug_func_new_save():
	var savelist = SaveScript.show_save_dir()
	var profN = "pisya"
	global.get_global_scene("main").profile_name = profN
	var save_id
	for i in savelist:
		if savelist[i][1] == global.get_global_scene("main").profile_name:
			print("найдена запись, перезапись файла сохранения ",i)
			save_id = i
			break
			
	var pos = global.get_player_pos()
	var key = global.player_indicators("key",0,"get")
	var hp = global.player_indicators("hp",0,"get")
	var coin = global.player_indicators("coin",0,"get")
	var door = OpenerList.opener_list
	var inv = itemlist.inventory
	var save_name = "new_game"
	var entities = Entities.entities
	SaveScript.create_save(save_id,profN,pos,key,hp,coin,door,inv,save_name,entities)
	global.get_global_scene("hud").set_info_label("SAVE COMPLITE",1,0.0001)
