extends Node2D

var opener_list: Dictionary = {}

func add_in_list(door_num:int, door_lvl:int):
	if !opener_list.has(door_num):
		opener_list[str(door_num)] = []
	var opener_status_1: bool = false
	var opener_status_2: bool = false
	var opener_status = [door_lvl,opener_status_1,opener_status_2]
	opener_list[str(door_num)].append(opener_status)
				

