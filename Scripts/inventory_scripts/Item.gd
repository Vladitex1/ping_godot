extends Node2D

func _ready():
	randomslots()


func randomslots():
	var num = randi_range(0, 4)
	#num = 1
	match num:
		0: ###Blocked_slot
			$TextureRect.texture = load("res://assets/interface/slot_block.png")
		1:
			print("select - item")
		2:
			$TextureRect.texture = load("res://assets/interface/coin.png")
		3:
			$TextureRect.texture = load("res://assets/interface/health1.png")
		4:
			$TextureRect.texture = load("res://assets/special/none.png")


