extends Area2D
@onready var door_timer =  $"../../Textures/Door_Timer"
@onready var door_animation = $"../../Textures/door_open_animation"
@onready var door_colision = $"../door_real_colision"
var door_tougle = false
var door_ready = false

func _on_body_entered(body:CharacterBody2D):
	if str(body.name) == "Player":
		print("вход в территорию двери")
		global.set_tougle(3,true)
		door_ready = true

func _on_body_exited(body:CharacterBody2D):
	if str(body.name) == "Player":
		print("выход из территории двери")
		door_ready = false
		global.set_tougle(3,false)
		
func animation(animation_bool):
	if !animation_bool:
		door_animation.play("door_open")
	else:
		door_animation.play("door_close")
		
func _process(_delta):
	if Input.is_action_just_released("press_key_event_on") and door_ready == true:
		global.set_tougle(2,true)
		if door_tougle == false:
			print("Дверь открыта")
			animation(door_tougle)
			door_tougle = true
			await get_tree().create_timer(1).timeout
		else:
			print("Дверь закрыта")
			animation(door_tougle)
			door_tougle = false
		
		
		door_ready = false
		global.set_tougle(2,false)
		global.set_tougle(3,false)
		
		door_colision.set_deferred("disabled",door_tougle)	
			
			
		

