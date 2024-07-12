extends Node2D
## DO NOT DELETE
var id:int = -1

func _process(_delta):
	$Enemy.enemy_id = id
	#print(id)
