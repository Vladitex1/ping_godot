extends Node2D

var CurrentID: int = -1

func get_slot_info():
	return CurrentID

func slot(num):
	var Texture1
	$TextureRect.texture = itemlist.itemlist[num][1]
	CurrentID = num


##передает значение куда положить
func _on_slot_mouse_control_mouse_entered(): ##работает если наведено
	#$"../../../..".selected_slot_id_end = CurrentID #возвращает значения задания предмет откуда взяли
	var slotnum: int
	#print(self.name)
	#print(self.clip_children)
	match str(self.name):##Возвращает значение слота на который нужен дроп
		"Item1":
			slotnum = 1
		"Item2":
			slotnum = 2
		"Item3":
			slotnum = 3
		"Item4":#
			slotnum = 4
		"Item5":
			slotnum = 5
		"Item6":
			slotnum = 6
		"Item7":
			slotnum = 7
		"Item8":
			slotnum = 8
		"Item9":
			slotnum = 9
		"Item10":
			slotnum = 10
		"Item11":#
			slotnum = 11
		"Item12":#
			slotnum = 12
		"Item13":
			slotnum = 13
		"Item14":
			slotnum = 14
		"Item15":
			slotnum = 15
		"Item16":
			slotnum = 16
			
	#$"../../../..".selected_slot_end = slotnum
