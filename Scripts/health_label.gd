extends Label


func _process(_delta):
	text = "health - "+str(global.PlayerIndicators("HP", 0, "get"))

