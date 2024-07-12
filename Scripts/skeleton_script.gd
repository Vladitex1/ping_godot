extends CharacterBody2D

@onready var attack_timer = $AttackTimer
@onready var cooldown_timer = $CooldownTimer
@onready var enemy_animation = $AnimatedSprite2D
@onready var health_bar = $health_bar
@onready var health_bar_lable = $healh_count_label
@onready var enemy = $"."

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

var attack_strange: int = -5
var attack_time: float = 1
var random_num: int
var speed: float
var timer:bool = false
var state = IDLE
var player = null
var last_movement = 2
var null_vector = Vector2(0,0)
var health_value = 150
var max_health = 150
var temp_state
var damaged = true
var enemy_id: int = -1
var patrol_timer = false
var new_vector: Vector2
#damage_zone_detection
func _ready():
	health_bar.max_value = max_health
	$enemy_damage_area.connect("body_entered",AttackArea_enter)
	$enemy_damage_area.connect("body_exited",AttackArea_exit)
	
	$detection.connect("body_entered",ChaseArea_enter)
	$detection.connect("body_exited",ChaseArea_exit)
	
	$get_damage_area.connect("area_entered",DamageArea_enter)
	#$get_damage_area.connect("area_exited",DamageArea_exit)
	
	$far_detection.connect("body_entered",PatrolArea_enter)
	$far_detection.connect("body_exited",PatrolArea_exit)
	
func _physics_process(delta):
	health_bar_conrol(SET)
	GSet_health(0,GET)
	
	if global.attack_tougle:
		temp_state = state
		state = DAMAGE

			
	match state:
		PATROL:
			speed = 50
			if attack_timer.is_stopped() == true:
				new_vector = get_circle_position(get_random_num())
				attack_timer.start(5)
			#print(attack_timer.time_left)
			#print("__________________________________________")
			#print(patrol_timer)
			#print("new_vector = "+str(new_vector))
			#print("enemy_position = "+str(enemy.get_global_position()))
			var delta_x = enemy.get_global_position().x-new_vector.x
			var delta_y = enemy.get_global_position().y-new_vector.y
			

			if delta_x<=0:
				delta_x *= -1
			if delta_y<=0:
				delta_y *= -1
			#print("delta_x = "+str(delta_x))
			#print("delta_y = "+str(delta_y))
			var delta_num = 2
			if delta_x < delta_num and delta_y < delta_num:
				animation(null_vector,null_vector,"idle")  
			else:
				move(new_vector, delta, speed)
			#print("Enemy state: Patrol - skeleton_script")
			
			temp_state = PATROL
		CHASE:
			speed = 150
			attack_timer.stop()
			global.action_tougle = false
			move(global.get_player_pos(), delta, speed)
			temp_state = CHASE
		ATTACK:
			speed = 10
			move(global.get_player_pos(), delta, speed)
			attack()
			animation(null_vector,null_vector,"idle")
			temp_state = ATTACK
		DAMAGE:
			animation(null_vector,null_vector,"damage")
			var incoming_damage = global.player_attack("damage", 0, "get")
			GSet_health(GSet_health(0,GET) - incoming_damage,SET)
			move(damage_vector(),1,10)
			state = temp_state
		DEATH:
			animation(null_vector,null_vector,"death")
			if enemy_animation.get_frame() == 3:
				global.PlayerIndicators("coin", 1, "set")	
				$".".queue_free()
		IDLE:
			animation(null_vector,null_vector,"idle")
			state = IDLE

###############special######################
func get_random_num():
	random_num = randi_range(0,180)
	return random_num

func move(target, delta, spd):
	var direction = (target - enemy_animation.get_global_position()).normalized() 
	var desired_velocity =  direction * spd
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering
	animation(velocity,steering,"walk")
	move_and_slide()
	
func GSet_health(Count:int,GS):
	if health_value <= 0:
		state = DEATH
	match GS:
		GET:
			return health_value
		SET:
			health_value = Count

func animation(vc,steering,condition):
	var walk = 0
	var more_than = 4
	
	if vc.x>steering.x and vc.x-steering.x>more_than: #right
		walk = 1
	elif vc.x<steering.x and vc.x-steering.x<more_than: #left
		walk = 2
	elif vc.y>steering.y and vc.y-steering.y>more_than: #up
		walk = 4
	elif vc.y<steering.y and vc.y-steering.y<more_than: #down
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
	var attack_speed: float = 0.5
	var cooldown_speed: float = 1
	global.heat_tougle = true
	if attack_timer.is_stopped() == true: ##запуск куладуна
		global.PlayerIndicators("hp",attack_strange,"set")
		cooldown_timer.start(cooldown_speed)
	if cooldown_timer.is_stopped() == true:
		global.heat_tougle = false
		global.PlayerIndicators("hp",0,"set")
	if cooldown_timer.is_stopped() == false: ##перезапуск таймера атаки
		attack_timer.start(attack_speed)
		
###############damage######################

func damage_vector():
	var num = global.player_attack("damage_throw", 0, "get")
	var enemy_angle = (global.get_player_pos() - enemy.get_global_position()).angle()	
	var vector_from_angle = Vector2(cos(enemy_angle), sin(enemy_angle))
	var vector = Vector2(num,num) * vector_from_angle
	var final_vector = enemy.get_global_position()+(vector*-1)
	return final_vector
	
###############chase######################
###############patrol######################
func get_circle_position(random):
	var radius = 200
	 #Distance from center to circumference of circle
	var angle = random# * PI * 2;
	var vector_from_angle = Vector2(cos(angle), sin(angle))
	var vector = Vector2(radius,radius) * vector_from_angle
	var final_vector = enemy.get_global_position()-vector
	return final_vector
	
func patrol_vector_timer(): ##перезапуск таймера
	print("время - skeleton_script: id = " + str(enemy_id))
	get_random_num()
	
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
	global.current_enemy_attack_id = enemy_id
	if str(body.name) == "player":
		state = ATTACK
		#IDLE#

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
	print(area.name)
	if str(area.name) == "Hands":
		state = DAMAGE
		
func DamageArea_exit(area):
	if str(area.name) == "Hands":
		state = temp_state
	

