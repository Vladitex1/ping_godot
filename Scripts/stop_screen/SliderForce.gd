extends Label

func _ready():
	print("slider Ready")
	$"../HSlider".value = global.brightness
func _process(delta):
	var abc = $"../HSlider".value
	global.brightness = abc
	text = "brightness: "+str(abc)

