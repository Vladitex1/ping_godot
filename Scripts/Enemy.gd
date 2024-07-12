extends CharacterBody2D

@onready var attack_timer = $AttackTimer
@onready var enemy_animation = $AnimatedSprite2D

var random_num

enum {
	PATROL,
	CHASE,
	ATTACK,
	}

var state = PATROL
var player = null
var player_chase = false

func _on_detection_body_entered(body:CharacterBody2D):
	if str(body.name) == "Player":
		player = body
		state = CHASE
		#print("Enter_enemy_col - Enemy")

func _on_detection_body_exited(body:CharacterBody2D):
	if str(body.name) == "Player":
		player = null
		state = PATROL
		#print("Exit_enemy_col - Enemy")

func _on_close_detection_body_entered(body:CharacterBody2D):
	if str(body.name) == "Player":
		state = ATTACK
func _on_close_detection_body_exited(body:CharacterBody2D):
	if str(body.name) == "Player":
		state = CHASE

func get_random_num():
	var random_number_generator = RandomNumberGenerator.new()
	random_number_generator.randomize()
	random_num = random_number_generator.randf()
	#return random_num
	
func _ready():
	get_random_num()

func _physics_process(delta):
	
	var speed: int
	
	match state:
		PATROL:
			speed = 50
			move(get_circle_position(random_num), delta, speed)
			patrol_vector_timer()
		CHASE:
			speed = 150
			move(global.get_player_pos(), delta, speed)
		ATTACK:
			speed = -5
			move(global.get_player_pos(), delta, speed)
			attack()
			enemy_animation.stop()


func move(target, delta, speed):
	var direction = (target - enemy_animation.get_global_position()).normalized() 
	var desired_velocity =  direction * speed
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering
	animation(velocity,steering)
	move_and_slide()
	
	
func attack():
	#var enemy_pos = enemy_animation.get_global_position()
	#var player_pos = global.get_player_pos()
	if attack_timer.is_stopped() == true:
		attack_timer.start(2)
		print("время - Enemy")
		global.heat_tougle = true
	else:
		global.heat_tougle = false

func animation(vc,steering):
	if vc.x>=steering.x:
		enemy_animation.play("walk_right")
	elif vc.x<=steering.x:
		enemy_animation.play("walk_left")
	elif vc.y<=steering.y:
		enemy_animation.play("walk_up")
	elif vc.y>=steering.y:
		enemy_animation.play("walk_down")
	else:
		enemy_animation.stop()
		
func get_circle_position(random):
	var kill_circle_centre = enemy_animation.get_global_position()
	var radius = 50
	 #Distance from center to circumference of circle
	var angle = random * PI * 2;
	var x = kill_circle_centre.x + cos(angle) * radius;
	var y = kill_circle_centre.y + sin(angle) * radius;

	return Vector2(x, y)
	
func patrol_vector_timer():
	if state == PATROL:
		#print(str(round(attack_timer.time_left))+" - Enemy")
		if attack_timer.is_stopped() == true:
			attack_timer.start(2)
			print("время - Enemy")
			get_random_num()
	else:
		return 0
		

