extends Control

var profile_name: String
@onready var profile_name_lideedit: Object = $ScrollContainer/VBoxContainer/profile_name_lineedit
@onready var parent_node = $"../.."

func _ready() -> void:
	var back_but = $newgame_menu/settings/Button_Back
	back_but.connect("button_up",back_button)
	var create_but = $newgame_menu/settings/Button_Create
	create_but.connect("button_up",create_button)


func back_button():
	global.get_global_scene("start_menu").select_menu("main")
	
	
func create_button():
	###ПРИКРУТИТЬ ЦИФРОВОЕ ОБОЗНАЧЕНИЕ СЕЙВА
	print("создание нового файла сохранения")
	var save_id: int = -1
	if SaveScript.show_save_dir().size() == 0:
		save_id = 0
	else:
		save_id = SaveScript.show_save_dir().size()
	print("запись по новому id: ", save_id)
	print("имя: ", str(profile_name_lideedit.get_text()))
	
	### СТАРТОВЫЕ ЗНАЧЕНИЯ
	var profN = str(profile_name_lideedit.get_text())
	var pos = Vector2(263, 279)
	var key:int = 0
	var hp:int = 100
	var coin:int = 5
	var door: Dictionary = {1:[[1,false,false]],2:[[2,false,false]]}
	var inv: Dictionary = {0:[1,1],1:[2,3],2:[3,6],3:[0,1],4:[-1,1],5:[-1,1],6:[-1,1],7:[-1,1],8:[-1,1],9:[-1,1],10:[-1,1],11:[-1,1],12:[-1,1],13:[-1,1],14:[-1,1],15:[-1,1]}
	var save_name = "new_save"
	var entities: Dictionary = {0:["skeleton","(773.002, 158.1351)",0,1,150], 1:["skeleton","(794.5625, 463.9682)",1,1,150]}
	SaveScript.create_save(save_id,profN,pos,key,hp,coin,door,inv,save_name,entities)
	var result: bool = false
	result = await $"../confirm_panel".confirm_show("Confirm?")
	match result:
		false:
			global.get_global_scene("start_menu").select_menu("main")
		true:
			global.del_scene("start_menu")
			global.add_scene("main1")
