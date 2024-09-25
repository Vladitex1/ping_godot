extends Node2D

var position_list: Dictionary = {}

func add_in_list(list_num:int,pos: Vector2):
	if !position_list.has(list_num):
		position_list[list_num] = []
	position_list[list_num].append(pos)



	
