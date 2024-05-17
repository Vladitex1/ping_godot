extends Area2D

@onready var door_tex_1 = $"../../Textures/Door1"
@onready var door_tex_2 = $"../../Textures/Door2"
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
		
func _process(delta):
	if Input.is_action_just_released("press_key_event_on") and door_ready == true:
		if door_tougle == false:
			print("Дверь открыта")
			door_tex_1.hide()
			door_tex_2.hide()
			door_tougle = true
		else:
			print("Дверь закрыта")
			door_tex_1.show()
			door_tex_2.show()
			door_tougle = false
		door_colision.set_deferred("disabled",door_tougle)

