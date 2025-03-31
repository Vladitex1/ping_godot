extends Node2D

var CurrentID: int = -1
var Count: int = 1
var Position: int = -1


func _ready():
	var equip_button = $"../../MarginContainer2/VBoxContainer/equip"
	var drop_button = $"../../MarginContainer2/VBoxContainer/drop"
	equip_button.connect("button_up",Callable(self, "equip_pressed"))
	drop_button.connect("button_up",Callable(self, "drop_pressed"))
	
func get_slot_info(num:int) -> int:
	match num:
		1:
			return CurrentID
		2:
			return Count
		3:
			return Position
		_:
			return 0
			

func slot(num:int,countnum:int):
	$TextureRect.texture = itemlist.itemlist[num]["TEXTURE"]
	discription(num)
	CurrentID = num
	Count = countnum
	
	var countlable_path = $"../countlable"
	countlable_path.text = str(Count)
	if Count > 1:
		countlable_path.visible = true
	else:
		countlable_path.visible = false
	

func discription(num:int):

	var info_name_path = $"../../MarginContainer/VBoxContainer/namespace"
	var info_discr_path = $"../../MarginContainer/VBoxContainer/discription"
	var info_cost_path = $"../../MarginContainer/VBoxContainer/cost"
	var info_rare_path = $"../../MarginContainer/VBoxContainer/rare"
	info_name_path.text = itemlist.itemlist[num]["NAME"]
	info_discr_path.text = "Discription:  " +itemlist.itemlist[num]["DISCRIPTION"]
	info_cost_path.text = "Cost: " + str(itemlist.itemlist[num]["SELLCOST"])
	info_rare_path.text = "Rare: " + itemlist.itemlist[num]["RARE"]
	
func equip_pressed():
	print("equip ",itemlist.itemlist[get_slot_info(1)]["NAME"])
	match get_slot_info(1):
		2:
			global.player_indicators("coin", 1, "set")
		3:
			global.player_indicators("key", 1, "set")
		1:
			global.player_indicators("hp", 15, "set")
	if get_slot_info(2) > 1:
		Count = Count - 1
		slot(get_slot_info(1),Count)
	else:
		slot(0,Count)
	$"../../MarginContainer2".visible = false
	global.get_global_scene("inventory").get_child(0).use_menu_break()
	global.get_global_scene("inventory").get_child(0).inventory_save()
	
func drop_pressed():
	print("drop ",itemlist.itemlist[get_slot_info(1)]["NAME"])
	loot(get_slot_info(1))
	if get_slot_info(2) > 1:
		Count = Count - 1
		slot(get_slot_info(1),Count)
	else:
		slot(0,Count)
	$"../../MarginContainer2".visible = false
	global.get_global_scene("inventory").get_child(0).use_menu_break()
	global.get_global_scene("inventory").get_child(0).inventory_save()
	
func loot(value1): ##спавн лута при дропе
	var name_of_root_scene: String = "main"
	var spawn = load("res://Scenes/objects/dynamic_loot.tscn").instantiate()
	spawn.position = global.get_player_pos()
	var node = get_tree().root.get_children()
	for i in node.size():
		#print(node[i].name)
		if node[i].name == name_of_root_scene:
			var drop_node = node[i].get_child(3)
			spawn.item = value1
			drop_node.add_child(spawn)			
