extends Control

@onready var stamina_bar = $plate/stamina_bar/stamina_bar
@onready var health_bar = $plate/health_bar/health_bar
@onready var healh_count_lable = $plate/health_bar/healh_count_label
@onready var coins_count_lable = $plate/items/coins_count_label
@onready var keys_count_lable = $plate/items/keys_count_label
@onready var FPS_lable = $plate/other/FPS
@onready var weapon_texture = $plate/plates/weapon_texture

var value: int  = 0
func _ready():
	stamina_bar.max_value = global.MaxStamina
	health_bar.max_value = global.MaxHealth
func _process(_delta):
	var fps = Engine.get_frames_per_second()
	FPS_lable.text = "fps: "+str(fps)
	stamina_bar.value = global.PlayerIndicators("stamina", 0, "get")
	health_bar.value = global.PlayerIndicators("hp", 0, "get")
	healh_count_lable.text = "health - "+str(global.PlayerIndicators("hp", 0, "get"))
	coins_count_lable.text = str(global.PlayerIndicators("coin", 0, "get"))
	keys_count_lable.text = str(global.PlayerIndicators("key", 0, "get"))
	#weapon_texture.texture =
