extends Control

@onready var stamina_bar = $plate/stamina_bar/stamina_bar
@onready var health_bar = $plate/health_bar/health_bar
@onready var healh_count_lable = $plate/health_bar/healh_count_label
@onready var coins_count_lable = $plate/items/coins_count_label
@onready var keys_count_lable = $plate/items/keys_count_label
@onready var FPS_lable = $plate/other/FPS

var value: int
func _ready():
	value = 0

func _process(delta):
	var fps = Engine.get_frames_per_second()
	FPS_lable.text = "fps: "+str(fps)
	stamina_bar.value = global.PlayerIndicators("HP", 0, "GET")
	health_bar.value = global.PlayerIndicators("HP", 0, "GET")
	healh_count_lable.text = "health - "+str(global.PlayerIndicators("HP", 0, "GET"))
	coins_count_lable.text = str(global.PlayerIndicators("COINS", 0, "GET"))
	keys_count_lable.text = str(global.PlayerIndicators("KEYS", 0, "GET"))

