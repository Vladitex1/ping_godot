extends CanvasLayer

@onready var stamina_bar = $control_module/HUD/stamina_bar
@onready var stamina_bar_limit = $control_module/HUD/stamina_bar_limit
@onready var health_bar = $control_module/HUD/health_bar
@onready var healh_count_label = $control_module/HUD/healh_count_label
@onready var coins_count_label = $control_module/HUD/coins_count_label
@onready var keys_count_label = $control_module/HUD/keys_count_label
@onready var FPS_label = $control_module/HUD/FPS
@onready var weapon_texture = $control_module/HUD/weapon_texture
@onready var info_label = $control_module/HUD/info_label
@onready var timer = $control_module/HUD/Timer

var value: int  = 0
func _ready():
	
	stamina_bar.max_value = global.max_stamina
	health_bar.max_value = global.max_health
	stamina_bar_limit.value = global.stamina_limit
	node_reset(config.BASE_RES_NUM)
	
func _process(_delta):
	
	#print("_______")
	
	#for i in $".".get_parent().get_child_count():
		#print($".".get_parent().get_child(i))

	var fps = Engine.get_frames_per_second()
	FPS_label.text = "fps: "+str(fps)
	stamina_bar.value = global.player_indicators("stamina", 0, "get")
	health_bar.value = global.player_indicators("hp", 0, "get")
	healh_count_label.text = "health - "+str(global.player_indicators("hp", 0, "get"))
	coins_count_label.text = str(global.player_indicators("coin", 0, "get"))
	keys_count_label.text = str(global.player_indicators("key", 0, "get"))
	#weapon_texture.texture =


func node_reset(res):
	var scaled = config.resolution_list[res][2]
	var positioned = Vector2(config.resolution_list[res][3],config.resolution_list[res][4])
	$control_module.scale = Vector2(scaled,scaled)
	$control_module.position = positioned


func set_info_label(SetText: String,timeout:float,Speed: float):
	print("set_info_text_lable = ", SetText)
	info_label.text = SetText
	var value = 0
	var rgb: Color
	while value < 1:
		await get_tree().create_timer(Speed).timeout
		value = value + 0.01
		info_label.set("theme_override_colors/font_color",Color(190,190,190,value))
		
	await get_tree().create_timer(timeout).timeout
	while value > 0:
		await get_tree().create_timer(Speed).timeout
		value = value - 0.01
		info_label.set("theme_override_colors/font_color",Color(190,190,190,value))
	
	
	
	
	
