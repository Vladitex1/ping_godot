extends Node2D

var CurrentID: int = -1


func _process(_delta):
	slot(CurrentID)
	
func get_slot_info():
	return CurrentID
	
func slot(num):
	$TextureRect.texture = itemlist.itemlist[num][1]
	CurrentID = num
