extends CanvasModulate

func _process(_delta):
	var value = global.brightness
	var rgb = Color(0+value,0+value,0+value)
	set_color(rgb)
