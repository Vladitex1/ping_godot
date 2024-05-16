extends Sprite2D

func _process(delta):
	if global.get_tougle(3) == true:
		show()
	else:
		hide()
