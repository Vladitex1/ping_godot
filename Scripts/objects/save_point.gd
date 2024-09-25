extends Node2D

@export var save_area_name: String

func _ready():
	$Area2D.connect("body_entered",create_save_point)

	
func create_save_point(body):
	if body.name == "player":
		
		var num = get_tree().root.get_child(1).name
		for i in get_tree().root.get_child_count():
			if get_tree().root.get_child(i).name == "main":
				num = get_tree().root.get_child(i).active_save
				
		var pos = global.get_player_pos()
		var key = global.player_indicators("key",0,"get")
		var hp = global.player_indicators("hp",0,"get")
		var coin = global.player_indicators("coin",0,"get")
		var door = OpenerList.opener_list
		var inv = itemlist.inventory
		var save_name = str(save_area_name)
		var entities = Entities.entities
		SaveScript.create_save(num,pos,key,hp,coin,door,inv,save_name,entities)
