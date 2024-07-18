extends CharacterBody2D

@onready var attack_timer = $AttackTimer
@onready var cooldown_timer = $CooldownTimer
@onready var enemy_animation = $AnimatedSprite2D
@onready var health_bar = $health_bar
@onready var health_bar_lable = $healh_count_label
@onready var enemy = $"."
@onready var hands = $enemy_hands
@onready var nav: NavigationAgent2D = $NavigationAgent2D
enum {
	PATROL, #0
	CHASE, #1
	ATTACK, #2
	DAMAGE, #3
	DEATH, #4
	IDLE, #5
	GET, #0
	SET, #0
	}

const standart_speed: float = 100

const max_health: int = 150
const attack_strange: int = -5
const attack_throw: int = -1000
const attack_speed: float = 0.5
const cooldown_speed: float = 1
const acceleration = 5

var health_value: int
var random_num: int
var speed: float
var timer:bool = false
var state = IDLE
var player = null
var last_movement = 2
var null_vector = Vector2(0,0)
var direction = Vector3()
var temp_state
var damaged = true
var patrol_timer = false
var new_vector: Vector2
var IFT = null
#damage_zone_detection
func _ready():
	hands.get_child(0).disabled = true
	health_value = max_health
	health_bar.max_value = max_health
	$attack_area.connect("body_entered",AttackArea_enter)
	$attack_area.connect("body_exited",AttackArea_exit)
	
	$detection.connect("body_entered",ChaseArea_enter)
	$detection.connect("body_exited",ChaseArea_exit)
	
	$damage_area.connect("area_entered",DamageArea_enter)
	#$damage_area.connect("area_exited",DamageArea_exit)
	
	$far_detection.connect("body_entered",PatrolArea_enter)
	$far_detection.connect("body_exited",PatrolArea_exit)
	
func _physics_process(_delta):
	health_bar_conrol(SET)
	GSet_health(0,GET)
	#print(global.player_attack("damage", 0, "get"))
			
	match state:
		PATROL:
			speed = standart_speed
			if attack_timer.is_stopped() == true:
				attack_timer.start(3)
				new_vector = get_circle_position()
								
			move(new_vector, _delta, speed)
			
			temp_state = PATROL
		CHASE:
			speed = standart_speed
			global.action_tougle = false
			nav.target_position = global.get_player_pos()
			direction = nav.target_position - global_position
			velocity = velocity.lerp(direction.normalized() * speed, acceleration * _delta) 
			
			nav.get_next_path_position()
			
			animation("walk")
			move_and_slide()
			
			
			temp_state = CHASE
		ATTACK:
			speed = 0
			move(global.get_player_pos(), _delta, speed)
			attack()
			animation("idle")
			temp_state = ATTACK
		DAMAGE:
			speed = 0
			var incoming_damage = global.player_attack("damage", 0, "get")
			var incoming_damage_throw = global.player_attack("damage_throw", 0, "get")
			GSet_health(GSet_health(0,GET) - incoming_damage,SET)
			#print(damage_vector(_delta))
			move(damage_vector(), 0.6, speed)
			animation("damage")
			state = temp_state
		DEATH:
			animation("death")
			if enemy_animation.get_frame() == 3:
				global.PlayerIndicators("coin", 1, "set")	
				$".".queue_free()
		IDLE:
			animation("idle")
			temp_state = IDLE

###############special######################

func move(target, _delta, spd):
	var direction = velocity + target
	velocity = velocity.lerp(direction.normalized() * speed, acceleration * _delta) 
	animation("walk")
	move_and_slide()
	
func GSet_health(Count:int,GS):
	if health_value <= 0:
		state = DEATH
	match GS:
		GET:
			return health_value
		SET:
			health_value = Count

func animation(condition):
	var walk = 0
	var dir
	if state == PATROL:
		dir = rad_to_deg(new_vector.angle())
	else:
		dir = rad_to_deg((global.get_player_pos() - enemy.get_global_position()).angle())
		#print(round(dir))
	var direction = round(dir)
	#print(direction)

	#print(state)
	#print(direction)
	if direction <= -135 or direction >= 135: #left
		walk = 2
	#elif direction <= 45: #right 
	if direction >= -135 and direction <= -45: #up
		walk = 3
	if direction <= 135 and direction >= 45: #down
		walk = 4
	if direction <= 45 and direction >= -45: #right
		walk = 1

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
					await get_tree().create_timer(1).timeout 
				2:
					enemy_animation.flip_h = true
					enemy_animation.play("skeleton_damage_side")
					await get_tree().create_timer(1).timeout 
				3:
					enemy_animation.play("skeleton_damage_up")
					await get_tree().create_timer(1).timeout 
				4:
					enemy_animation.play("skeleton_damage_down")
					await get_tree().create_timer(1).timeout 
				_:
					enemy_animation.stop()
		"death":
			match last_movement:
				1:
					enemy_animation.flip_h = false
					enemy_animation.play("skeleton_death_side")
					await get_tree().create_timer(1).timeout 
				2:
					enemy_animation.flip_h = true
					enemy_animation.play("skeleton_death_side")
					await get_tree().create_timer(1).timeout 
				3:
					enemy_animation.play("skeleton_death_up")
					await get_tree().create_timer(1).timeout 
				4:
					enemy_animation.play("skeleton_death_down")
					await get_tree().create_timer(1).timeout 
				_:
					enemy_animation.stop()

func out_state_conrol(setter):
	state = setter
###############health_bar_conrol######################

func health_bar_conrol(GS):
	match GS:
		GET:
			pass
		SET:
			if health_value >= max_health:
				health_bar_lable.visible = false
				health_bar.visible = false
			elif health_value <= max_health:
				health_bar_lable.visible = true
				health_bar.visible = true
				health_bar.value = health_value
				health_bar_lable.text = str(health_value)
			elif health_value <= 0:
				health_bar_lable.visible = false
				health_bar.visible = false

###############atack######################

func attack():
	
	#print(attack_timer.time_left)
	#print(cooldown_timer.time_left)
	if attack_timer.time_left != 0:
		hands.get_child(0).disabled = true
	if attack_timer.time_left > 0.1:
		cooldown_timer.start(cooldown_speed)
		hands.get_child(0).disabled = false
	if cooldown_timer.time_left == 0:
		attack_timer.start(attack_speed)
		

		
###############damage######################

	
func damage_vector() -> Vector2:
	var player_position = global.get_player_pos()
	var enemy_position = enemy.global_position
	var knockback_distance = 20  # Установите нужное значение расстояния
	var direction: Vector2 = (enemy_position - player_position).normalized()
	var knockback_vector: Vector2 = enemy_position + direction * knockback_distance#s * knockback_force
	return knockback_vector

	
	
###############chase######################o
###############patrol######################
func get_circle_position():
	var min = -180
	var max = 180
	var randnum1 = randi_range(min,max)
	#var randnum2 = randi_range(min,max)
	#print("randnum1:",randnum1," randnum2",randnum2)
	var vector_from_angle = Vector2(cos(randnum1), sin(randnum1)) * 100
	#var radius = 10Vector2(radius,radius) * 
	#print(vector_from_angle)
	var vector = vector_from_angle
	return vector
	
	
###############connections######################		

func ChaseArea_enter(body):
	if str(body.name) == "player":
		player = body
		state = CHASE
		print("Enter_enemy_col - skeleton_script")

func ChaseArea_exit(body):
	if str(body.name) == "player":
		player = null
		state = PATROL
		print("Exit_enemy_col - skeleton_script")

func AttackArea_enter(body):
	if str(body.name) == "player":
		IFT = true
		state = ATTACK

func AttackArea_exit(body):
	if str(body.name) == "player":
		state = CHASE
		
func PatrolArea_enter(body):
	if str(body.name) == "player":
		state = PATROL
		
func PatrolArea_exit(body):
	if str(body.name) == "player":
		state = IDLE

		
func DamageArea_enter(area):
	if str(area.name) == "Hands":
		state = DAMAGE

func DamageArea_exit(area):
	if str(area.name) == "Hands":
		state = temp_state
	

