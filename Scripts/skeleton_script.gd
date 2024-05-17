extends CharacterBody2D

@onready var attack_timer = $AttackTimer
@onready var enemy_animation = $AnimatedSprite2D

var random_num
var speed
enum {
	PATROL,
	CHASE,
	ATTACK,
	DAMAGE,
	DEATH,
	IDLE,
	}

var state = IDLE
var player = null
var last_movement = 2
static var null_vector = Vector2(0,0)

func _on_detection_body_entered(body:CharacterBody2D):
	if str(body.name) == "Player":
		player = body
		state = CHASE
		print("Enter_enemy_col")

func _on_detection_body_exited(body:CharacterBody2D):
	if str(body.name) == "Player":
		player = null
		state = PATROL
		print("Exit_enemy_col")

func _on_close_detection_body_entered(body:CharacterBody2D):
	if str(body.name) == "Player":
		state = ATTACK
		
func _on_close_detection_body_exited(body:CharacterBody2D):
	if str(body.name) == "Player":
		state = CHASE
		
func _on_far_detection_body_entered(body:CharacterBody2D):
	if str(body.name) == "Player":
		state = PATROL
		
func _on_far_detection_body_exited(body:CharacterBody2D):
	if str(body.name) == "Player":
		state = IDLE

func get_random_num():
	var random_number_generator = RandomNumberGenerator.new()
	random_number_generator.randomize()
	random_num = random_number_generator.randf()
	#return random_num
	
func _ready():
	get_random_num()

func _physics_process(delta):
	
	match state:
		PATROL:
			speed = 50
			move(get_circle_position(random_num), delta, speed)
			#print("Enemy state: Patrol")
			patrol_vector_timer()
		CHASE:
			speed = 150
			move(global.get_player_pos(), delta, speed)
			#print("Enemy state: CHASE")
			#Slash ANIM
		ATTACK:
			#global.set_tougle(4,true)
			print("атака")
			speed = -1
			move(global.get_player_pos(), delta, speed)
			attack()
			animation(null_vector,null_vector,"idle")
			#enemy_animation.stop()
		DAMAGE:
			move(damage(),delta,speed)
		#DEATH:
		IDLE:
			
			animation(null_vector,null_vector,"idle")

func damage():
	var enemy_pos = enemy_animation.get_global_position()
	var vector_x = enemy_pos.x - global.get_player_pos().x
	var vector_y = enemy_pos.y - global.get_player_pos().y
	var x = 0
	var y = 0
	var damage_vector = Vector2(x,y)
	if vector_y > 0:
		x = 5
	else:
		x = -5
	if vector_y > 0:
		y = 5
	else:
		y = -5

	return damage_vector

func move(target, delta, speed):
	var direction = (target - enemy_animation.get_global_position()).normalized() 
	var desired_velocity =  direction * speed
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering
	animation(velocity,steering,"walk")
	move_and_slide()
	
	
func attack():
	var enemy_pos = enemy_animation.get_global_position()
	var player_pos = global.get_player_pos()
	if attack_timer.is_stopped() == true:
		attack_timer.start(2)
		print("время")
		global.set_tougle(4,true)
	else:
		global.set_tougle(4,false)
	
	
func animation(velocity,steering,condition):
	var walk = 0
	var more_than = 4
	
	##############################################################################не работает
	
	#if steering.x < steering.y:
	if velocity.x>steering.x and velocity.x-steering.x>more_than: #right
		walk = 1
	elif velocity.x<steering.x and velocity.x-steering.x<more_than: #left
		walk = 2
	#elif steering.x > steering.y:
	elif velocity.y>steering.y and velocity.y-steering.y>more_than: #up
		walk = 4
	elif velocity.y<steering.y and velocity.y-steering.y<more_than: #down
		walk = 3
	
		
	match condition:
		"walk":
			match walk:
				1:
					enemy_animation.flip_h = false
					enemy_animation.play("skeleton_walk_side")
					last_movement = 1
				2:
					enemy_animation.flip_h = true
					enemy_animation.play("skeleton_walk_side")
					last_movement = 2
				3:
					enemy_animation.play("skeleton_walk_up")
					last_movement = 3
				4:
					enemy_animation.play("skeleton_walk_down")
					last_movement = 4
				_:
					enemy_animation.stop()
		"idle":
			match last_movement:
				1:
					enemy_animation.flip_h = false
					enemy_animation.play("skeleton_idle_side")
				2:
					enemy_animation.flip_h = true
					enemy_animation.play("skeleton_idle_side")
				3:
					enemy_animation.play("skeleton_idle_up")
				4:
					enemy_animation.play("skeleton_idle_down")
				_:
					enemy_animation.stop()
		"damage":
			match last_movement:
				1:
					enemy_animation.flip_h = false
					enemy_animation.play("skeleton_damage_side")
				2:
					enemy_animation.flip_h = true
					enemy_animation.play("skeleton_damage_side")
				3:
					enemy_animation.play("skeleton_damage_up")
				4:
					enemy_animation.play("skeleton_damage_down")
				_:
					enemy_animation.stop()
		
func get_circle_position(random):
	var kill_circle_centre = enemy_animation.get_global_position()
	var radius = 200
	 #Distance from center to circumference of circle
	var angle = random * PI * 2;
	var x = kill_circle_centre.x + cos(angle) * radius;
	var y = kill_circle_centre.y + sin(angle) * radius;

	return Vector2(x, y)
	
func patrol_vector_timer():
	if state == PATROL:
		#print(str(round(attack_timer.time_left)))
		if attack_timer.is_stopped() == true:
			attack_timer.start(5)
			print("время")
			get_random_num()
	else:
		return 0
		


