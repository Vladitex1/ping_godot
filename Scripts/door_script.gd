extends Node2D

@onready var door_mask = $door_colisions/door_mask

var door_tougle = false
var door_ready = false

func _ready():
	$opener_area.connect("body_entered",body_entered)
	$opener_area.connect("body_exited",body_exited)
	
func animation(animation_bool):
	if animation_bool:
		door_mask.play("door_mask_open")
	else:
		door_mask.play_backwards("door_mask_open")	

func tougle():
	if door_tougle == true:
		door_tougle = false
	else:
		door_tougle = true
		
	match door_tougle:
		true:##открытие/закрытие двери переключатель
			global.loading_tougle = true
			animation(door_tougle)
		false:
			if global.PlayerIndicators("key", 0, "get") >= 1:
				global.loading_tougle = true
				global.PlayerIndicators("key", -1, "set")
				animation(door_tougle)
			elif global.PlayerIndicators("key", 0, "get") <= 0:
				pass
					
	await get_tree().create_timer(1).timeout 
	door_ready = false
	global.loading_tougle = false
	global.action_tougle = false
		
func _process(_delta):
	if Input.is_action_just_released("special_use") and door_ready == true:
		tougle()
			
func body_entered(body):
	if str(body.name) == "player":
		door_ready = true
		global.action_tougle = true
		
func body_exited(body):
	if str(body.name) == "player":
		door_ready = false
		global.action_tougle = false
		

