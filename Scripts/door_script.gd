extends Node2D

@onready var door_mask = $door_colisions/door_mask

var door_toggle = false
var door_ready = false

func _ready():
	$opener_area.connect("body_entered",body_entered)
	$opener_area.connect("body_exited",body_exited)
	
func _process(_delta):
	if Input.is_action_just_released("special_use") and door_ready == true:
		toggle()

func toggle():
	if door_toggle == true:
		door_toggle = false
	else:
		door_toggle = true
		
	match door_toggle:
		true:##открытие/закрытие двери переключатель
			global.loading_toggle = true
			animation(door_toggle)
		false:
			if global.player_indicators("key", 0, "get") >= 1:
				global.loading_toggle = true
				global.player_indicators("key", -1, "set")
				animation(door_toggle)
			elif global.player_indicators("key", 0, "get") <= 0:
				pass
					
	await get_tree().create_timer(1).timeout 
	door_ready = false
	global.loading_toggle = false
	global.action_toggle = false
		
func animation(animation_bool):
	if animation_bool:
		door_mask.play("door_mask_open")
	else:
		door_mask.play_backwards("door_mask_open")
		
func body_entered(body):
	if str(body.name) == "player":
		door_ready = true
		global.action_toggle = true
		
func body_exited(body):
	if str(body.name) == "player":
		door_ready = false
		global.action_toggle = false
		

