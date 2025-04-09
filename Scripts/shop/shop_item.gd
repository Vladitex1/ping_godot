extends Node2D

var CurrentID: int = -1
var discription_option: bool = false
#func _process(_delta):
	#slot(CurrentID)
	
func get_slot_info():
	return CurrentID
	
func get_discr_info():
	return discription_option
	
func slot(num:int,numpad: bool,discription: bool):
	discription_option = discription
	if numpad:
		if num == -256:
			$"..".text = ""
		else:
			$"..".text = (str(num))
		CurrentID = num
	else:
		$TextureRect.texture = itemlist.itemlist[num]["TEXTURE"]
		discription(num)
		CurrentID = num

func discription(num:int):
	if discription_option:
		var info_name_path = $"../../MarginContainer/VBoxContainer/namespace"
		var info_discr_path = $"../../MarginContainer/VBoxContainer/discription"
		var info_cost_path = $"../../MarginContainer/VBoxContainer/cost"
		var info_rare_path = $"../../MarginContainer/VBoxContainer/rare"
		info_name_path.text = itemlist.itemlist[num]["NAME"]
		info_discr_path.text = "Discription:  " +itemlist.itemlist[num]["DISCRIPTION"]
		info_cost_path.text = "Cost: " + str(itemlist.itemlist[num]["SELLCOST"])
		info_rare_path.text = "Rare: " + itemlist.itemlist[num]["RARE"]
	
