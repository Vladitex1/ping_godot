extends CanvasModulate

func _process(_delta):
	var value2 = global.brightness
	var abc = Color(0+value2,0+value2,0+value2)
	set_color(abc)
