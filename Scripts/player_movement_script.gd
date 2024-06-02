extends CharacterBody2D

static var speed = 150
static var sprint = 100
static var temp_sprit = sprint
var delta = 1
var is_first_try = true
@onready var player_animation = $Ping_Aimation
@onready var player = $PingColision

	
func get_input():
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if Input.is_action_pressed("move_shift"):
		sprint	= temp_sprit
	else:
		sprint = 0
	velocity = input_dir * (speed + sprint)
	
	if Input.is_action_just_released("special_back"):
		print("stop_screen")
		global.add_scene("stop_screen")
	
func animation():
	if Input.is_action_pressed("move_right"):
		player_animation.play("walk_right")
	elif Input.is_action_pressed("move_left"):
		player_animation.play("walk_left")
	elif Input.is_action_pressed("move_up"):
		player_animation.play("walk_up")
	elif Input.is_action_pressed("move_down"):
		player_animation.play("walk_down")
	else:
		player_animation.stop()
	
func update_player_position():
	global.set_player_pos(player.get_global_position())
	
#func _on_hands_body_entered(body):
	#pass # Replace with function body.


#func _on_hands_body_exited(body):
	#pass # Replace with function body.
	
func _process(_delta):
	get_input()
	move_and_slide()
	animation()
	update_player_position()



