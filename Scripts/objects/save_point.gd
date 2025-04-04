extends Node2D
@onready var AnimPlayer = $AnimationPlayer
@export var save_area_name: String
#print("вход ",num)
func _ready():
	$brain/Area2D.connect("body_entered",create_save_point)
	AnimPlayer.play("wobling")

func create_save_point(body):
	var save_found:bool
	var prof_name = global.get_global_scene("main").profile_name
	if body.name == "player":
		var savelist = SaveScript.show_save_dir()
		if savelist.size() == 0:
			save(0)
		else:
			for i in savelist:
				if savelist[i][1] == prof_name:
					print("найдена запись, перезапись файла сохранения ",i)
					save(i)
					save_found = true
					break
			if !save_found:
				print("не найдена запись, запись нового сохранения ")
				create_new_save_point()
	
func create_new_save_point():
	print("write")
	var save_id: int = -1
	if SaveScript.show_save_dir().size() == 0:
		save_id = 0
	else:
		save_id = SaveScript.show_save_dir().size()
	print("запись по новому id: ", save_id)
	save(save_id)
	
func save(save_id:int):
	var profN = global.get_global_scene("main").profile_name
	var pos = global.get_player_pos()
	var key = global.player_indicators("key",0,"get")
	var hp = global.player_indicators("hp",0,"get")
	var coin = global.player_indicators("coin",0,"get")
	var door = OpenerList.opener_list
	var inv = itemlist.inventory
	var save_name = str(save_area_name)
	var entities = Entities.entities
	SaveScript.create_save(save_id,profN,pos,key,hp,coin,door,inv,save_name,entities)
	global.get_global_scene("hud").set_info_label("SAVE COMPLITE",1,0.0001)
