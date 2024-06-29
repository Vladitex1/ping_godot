extends Label

var coins_num = 100

func _process(_delta):
	text = str(global.PlayerIndicators("Coins", 0, "get"))
