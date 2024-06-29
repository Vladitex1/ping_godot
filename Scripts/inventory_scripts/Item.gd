extends Node2D

var CurrentID: int = -1

static var blocked_texture = preload("res://assets/interface/slot_block.png")
static var interactive_texture = preload("res://assets/interface/interactive.png")
static var coin_texture = preload("res://assets/interface/coin.png")
static var continuebutton2_texture = preload("res://assets/interface/continuebutton2.png")
static var none_texture = preload("res://assets/special/none.png")

func get_slot_info():
	return CurrentID

func slot(num):
	match num:
		0: ###Blocked_slot
			$TextureRect.texture = global.itemlist["blocked"][1]
		1:
			$TextureRect.texture = global.itemlist["null"][1]
		2:
			$TextureRect.texture = global.itemlist["example_1"][1]
		3:
			$TextureRect.texture = global.itemlist["example_2"][1]
		4:
			$TextureRect.texture = global.itemlist["coin"][1]
		_:
			pass
	CurrentID = num

##передает значение куда положить
func _on_slot_mouse_control_mouse_entered(): ##работает если наведено
	$"../../../..".selected_slot_id_end = CurrentID #возвращает значения задания предмет откуда взяли
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
	$"../../../..".selected_slot_end = slotnum
