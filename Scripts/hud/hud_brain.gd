extends Control

@onready var stamina_bar = $plate/stamina_bar/stamina_bar
@onready var stamina_bar_limit = $plate/stamina_bar/stamina_bar_limit
@onready var health_bar = $plate/health_bar/health_bar
@onready var healh_count_lable = $plate/health_bar/healh_count_label
@onready var coins_count_lable = $plate/items/coins_count_label
@onready var keys_count_lable = $plate/items/keys_count_label
@onready var FPS_lable = $plate/other/FPS
@onready var weapon_texture = $plate/plates/weapon_texture
@onready var icon_animation = $plate/icon/icon_animation
var value: int  = 0
func _ready():

	stamina_bar.max_value = global.max_stamina
	health_bar.max_value = global.max_health
	stamina_bar_limit.value = global.stamina_limit
	icon_animation.play()
func _process(_delta):

	var fps = Engine.get_frames_per_second()
	FPS_lable.text = "fps: "+str(fps)
	stamina_bar.value = global.player_indicators("stamina", 0, "get")
	health_bar.value = global.player_indicators("hp", 0, "get")
	healh_count_lable.text = "health - "+str(global.player_indicators("hp", 0, "get"))
	coins_count_lable.text = str(global.player_indicators("coin", 0, "get"))
	keys_count_lable.text = str(global.player_indicators("key", 0, "get"))
	#weapon_texture.texture =
