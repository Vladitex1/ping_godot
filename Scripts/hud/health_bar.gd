extends TextureProgressBar


func _ready():
	value = 0

func _process(delta):
	value = global.PlayerIndicators("HP", 0, "get")
