extends CharacterBody2D

var speed = 150
var delta = 10
var sprint = 150
var tempsprint = sprint
var action_tougle = false

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _interactive = $Interactive

func movement(): #передвижение
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if Input.is_action_pressed("move_shift"):
		sprint	= tempsprint
	else:
		sprint = 0
		
	velocity = input_dir * (speed + sprint)

func animation():
	if Input.is_action_pressed("move_right"):
		_animated_sprite.play("walk_right")
	if Input.is_action_pressed("move_left"):
		_animated_sprite.play("walk_left")
	if Input.is_action_pressed("move_up"):
		_animated_sprite.play("walk_up")
	if Input.is_action_pressed("move_down"):
		_animated_sprite.play("walk_down")
	if !Input.is_action_pressed("move_left") && !Input.is_action_pressed("move_right") && !Input.is_action_pressed("move_down") && !Input.is_action_pressed("move_up"):
		_animated_sprite.stop()
		
func actions():
	if action_tougle == true:
		_interactive.show()
		if Input.is_action_just_released("press_key_event_on"):
			print("тык")
	else:
		_interactive.hide()
		
	
'func _on_area_2d_body_exited(body):
	print("выход из территории")
	action_tougle = false

func _on_area_2d_body_entered(body):
	print("вход в территорию")
	action_tougle = truе'
	
func _on_shop_area_exited_(area):
	print("выход из территории магазина")
	action_tougle = false


func _on_shop_area_entered(area):
	print("вход в территорию магазина")
	action_tougle = true
	
	
func _on_door_area_entered(area):
	print("вход в территорию двери")
	action_tougle = true

func _on_door_area_exited(area):
	print("выход из территории двери")
	action_tougle = false
	
func _physics_process(delta):
	movement()
	move_and_slide()
	animation()
	actions()
	




	






