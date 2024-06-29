extends ColorRect

func _process(_delta):
	if global.get_tougle(4) == true:
		show()
	else:
		hide()
