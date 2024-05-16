extends Sprite2D

func _process(delta):
	if global.get_tougle(4) == true:
		show()
	else:
		hide()
