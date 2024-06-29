extends Label

var keys_num = 100

func _process(_delta):
	text = str(global.PlayerIndicators("Keys", 0, "get"))
