extends CharacterBody2D

static var speed = 150
static var sprint = 100
static var temp_sprit = sprint
var delta = 1
var is_first_try = true
var player_align: String
var attack_state: bool = false
@onready var player_animation = $Ping_Aimation
@onready var player = $PingColision

enum {
	IDLE,
	WALK,
	}

var state = IDLE

	
	
func state_switcher():	
	if Input.is_anything_pressed():
		state = WALK
	else:
		state = IDLE
			
func get_input():
	
	if attack_state == false:
		var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		
		if Input.is_action_pressed("move_shift"):
			sprint	= temp_sprit
		else:
			sprint = 0
		velocity = input_dir * (speed + sprint)
		
	else:
		pass
		
	if Input.is_action_just_released("debug1"):
		global.PlayerIndicators("Keys", 1, "set")	
		print(global.PlayerIndicators("Keys", 0, "get"))
	
	if Input.is_action_just_released("special_back"):
		global.add_scene("stop_screen")
		print("стоп - он - player_movement_script")

		
var timer_delay = 1
func animation(input: bool):
	if input:
		if Input.is_action_pressed("move_right") and attack_state == false:
			player_animation.play("walk_right")
		elif Input.is_action_pressed("move_left") and attack_state == false:
			player_animation.play("walk_left")
	
		elif Input.is_action_pressed("move_up") and attack_state == false:
			player_animation.play("walk_up")

		elif Input.is_action_pressed("move_down") and attack_state == false:
			player_animation.play("walk_down")
	
		elif Input.is_action_pressed("attack") and player_align == "right":
			player_animation.flip_h = false
			player_animation.play("attack")
			attack_state = true
			await get_tree().create_timer(timer_delay).timeout 
			attack_state = false

		elif Input.is_action_pressed("attack") and player_align == "left":
			player_animation.flip_h = true
			player_animation.play("attack")
			attack_state = true
			await get_tree().create_timer(timer_delay).timeout 
			attack_state = false

		else:
			player_animation.stop()
	else:
		player_animation.play("idle")
	
func update_player_position():
	global.set_player_pos(player.get_global_position())
	var mouse_position = get_global_mouse_position()
	var player_position = player.get_global_position()
	var align = player_position-mouse_position
	if align[0] >= 0:
		player_align = "left"
	else:
		player_align = "right"
		
	
func _physics_process(_delta):
	get_input()
	state_switcher()
	match state:
		WALK:
			move_and_slide()
			animation(true)
		IDLE:
			animation(false)
	update_player_position()
	




