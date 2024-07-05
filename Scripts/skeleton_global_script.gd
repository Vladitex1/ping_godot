extends Node2D

var id:int = -1

func _process(delta):
	$Enemy.enemy_id = id
	#print(id)
