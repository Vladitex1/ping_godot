extends Node2D

var id:int = -1
var dict1 = {}
func _process(delta):
	$Player.enemy_max = id
	if len(dict1) > id:
		#print("______________________________________")
		$Player.enemy_list = {}
		#pass
	else:
		$Player.enemy_list = dict1
	
	#print(dict)
