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
	
	var profN = str(profile_name_lideedit.get_text())
	var pos = Vector2(0,0)
	var key:int = 0
	var hp:int = 0
	var coin:int = 0
	var door: Dictionary = {}
	var inv: Dictionary = {}
	var save_name = "new_save"
	var entities: Dictionary = {}
	SaveScript.create_save(save_id,profN,pos,key,hp,coin,door,inv,save_name,entities)
	var result: bool = false
	result = await $"../confirm_panel".confirm_show("Confirm?")
	match result:
		false:
			global.get_global_scene("start_menu").select_menu("main")
		true:
			global.del_scene("start_menu")
			global.add_scene("main1")
