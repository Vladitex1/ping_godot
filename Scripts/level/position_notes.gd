extends Node2D

var position_list: Dictionary = {}

func add_in_list(list_num:int,pos: Vector2):
	if !position_list.has(list_num):
		position_list[list_num] = []
	position_list[list_num].append(pos)
		
		
	#position_list[list_num][0].append(pos)

#func _process(delta):
	#print(position_list[1])
