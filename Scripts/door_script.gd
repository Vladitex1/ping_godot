extends Area2D

@onready var door_animation = $"../../Textures/door_open_animation"
@onready var door_colision = $"../door_real_colision"
@onready var door_mask_close = $"../../light_mask_close"
@onready var door_mask_open1 = $"../../light_mask_open_1"
@onready var door_mask_open2 = $"../../light_mask_open_2"

var door_tougle = false
var door_ready = false

func _on_body_entered(body):
	if str(body.name) == "player":
		print("вход в территорию двери - door_script")
		global.action_tougle = true
		door_ready = true

func _on_body_exited(body):
	if str(body.name) == "player":
		print("выход из территории двери - door_script")
		door_ready = false
		global.action_tougle = false
		
func animation(animation_bool):
	if !animation_bool:
		door_animation.play("door_open")
		door_mask_close.hide()
		door_mask_open1.show()
		door_mask_open2.show()
	else:
		door_animation.play("door_close")
		door_mask_open1.hide()
		door_mask_open2.hide()
		door_mask_close.show()


		
func _process(_delta):
	if Input.is_action_just_released("special_use") and door_ready == true:
		
		match door_tougle:
			true:
				global.loading_tougle = true
				print("Дверь закрыта - door_script")
				animation(door_tougle)
				door_tougle = false ##открытие/закрытие двери переключатель
			false:
				if global.PlayerIndicators("key", 0, "get") >= 1:
					global.loading_tougle = true
					global.PlayerIndicators("key", -1, "set")
					print("Дверь открыта - door_script")
					animation(door_tougle)
					door_tougle = true ##открытие/закрытие двери переключатель
				if global.PlayerIndicators("key", 0, "get") <= 0:
					pass


		await get_tree().create_timer(1).timeout 
		door_ready = false
		global.loading_tougle = false
		global.action_tougle = false
		door_colision.set_deferred("disabled",door_tougle)	
			
			
		

