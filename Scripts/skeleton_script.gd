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
	PURSUIT, #1
	ATTACK, #2
	DAMAGE, #3
	DEATH, #4
	IDLE, #5
	GET, #0
	SET, #0
	}

const standart_speed: float = 100

const max_health: int = 150
const attack_strange: int = 5
const attack_throw: int = 30
const attack_speed: float = 1
const cooldown_time: float = 1
const acceleration = 5

const debug_freeze = true

var damage_final_vector: Vector2
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
var damage_area = false
var attack_area = false
var patrol_timer = false
var new_vector: Vector2
var IFT = null
#damage_zone_detection
func _ready():
	health_value = max_health
	health_bar.max_value = max_health
	$enemy_hands.connect("body_entered",AttackArea_enter)
	$enemy_hands.connect("body_exited",AttackArea_exit)

	$detection.connect("body_entered",PursuitArea_enter)
	$detection.connect("body_exited",PursuitArea_exit)
	
	$damage_area.connect("area_entered",DamageArea_enter)
	$damage_area.connect("area_exited",DamageArea_exit)
	
	
func _physics_process(_delta):
	health_bar_conrol(SET)
	
	#print(global.player_attack("damage", 0, "get"))
	#print(state)
	
	if GSet_health(0,GET) <= 0:
		death()
	elif global.player_attack("damage", 0, "get") > 0 and damage_area:
		damage()
		state = DAMAGE
	elif attack_area and cooldown_timer.time_left < 0.1:
		attack()
	else:
		global.player_damage("damage",0,"set")
		global.player_damage("damage_throw",0,"set")
		match state:
			PATROL:
				speed = standart_speed
				if attack_timer.time_left < 0.1:
					attack_timer.start(1)
					new_vector = get_circle_position()			
				move(new_vector, _delta, speed)

			PURSUIT:
				speed = standart_speed
				global.action_tougle = false
				nav.target_position = player.global_position
				direction = nav.target_position - global_position
				velocity = velocity.lerp(direction.normalized() * speed, acceleration * _delta) 
				nav.get_next_path_position()
				animation("walk")
				move_and_slide()
			DAMAGE:
				
				if !move(damage_final_vector,_delta,speed):
					pass
				else:	
					state = PURSUIT
							
			IDLE:
				animation("idle")

###############special######################

func move(target, _delta, spd):
	#print(target)
	nav.target_position = target
	nav.get_next_path_position()
	velocity = position.direction_to(target) * spd
	if position.distance_to(target) > 10:
		move_and_slide()
		return false
	return true
	
	

func animation(condition):
	var walk = 0
	var dir
	if state == PATROL:
		dir = rad_to_deg(new_vector.angle())
	else:
		dir = rad_to_deg((global.get_player_pos() - enemy.get_global_position()).angle())
	var direction = round(dir)

	if direction <= 45 and direction >= -45: #right
		walk = 1
		enemy_animation.flip_h = false
	if direction <= -135 or direction >= 135: #left
		walk = 2
		enemy_animation.flip_h = true
	if direction >= -135 and direction <= -45: #up
		walk = 3
	if direction <= 135 and direction >= 45: #down
		walk = 4


	match condition:
		"walk":
			match walk:
				1:
					enemy_animation.play("skeleton_walk_side")
					last_movement = 1
				2:
					enemy_animation.play("skeleton_walk_side")
					last_movement = 2
				3:
					enemy_animation.play("skeleton_walk_up")
					last_movement = 3
				4:
					enemy_animation.play("skeleton_walk_down")
					last_movement = 4
		"idle":
			match last_movement:
				1:
					enemy_animation.play("skeleton_idle_side")
				2:
					enemy_animation.play("skeleton_idle_side")
				3:
					enemy_animation.play("skeleton_idle_up")
				4:
					enemy_animation.play("skeleton_idle_down")
		"damage":
			match last_movement:
				1:
					enemy_animation.play("skeleton_damage_side")
				2:
					enemy_animation.play("skeleton_damage_side")
				3:
					enemy_animation.play("skeleton_damage_up")
				4:
					enemy_animation.play("skeleton_damage_down")
			await get_tree().create_timer(2).timeout 
		"death":
			match last_movement:
				1:
					enemy_animation.flip_h = false
					enemy_animation.play("skeleton_death_side")
					await get_tree().create_timer(2).timeout
				2:
					enemy_animation.flip_h = true
					enemy_animation.play("skeleton_death_side")
					await get_tree().create_timer(2).timeout
				3:
					enemy_animation.play("skeleton_death_up")
					await get_tree().create_timer(2).timeout
				4:
					enemy_animation.play("skeleton_death_down")
					await get_tree().create_timer(2).timeout
			 

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

func GSet_health(Count:int,GS):
	match GS:
		GET:
			return health_value
		SET:
			health_value = Count



###############damage######################

func damage_vector() -> Vector2:
	var str: String
	var player_position = global.get_player_pos()
	var enemy_position = enemy.global_position
	var dist = global.player_attack("damage_throw",0,"get")
	var throw: Vector2 = Vector2(dist,dist)
	var dir: Vector2 = (player_position - enemy_position).normalized()
	var vector_from = Vector2(snapped(dir[0],1),snapped(dir[1],1))
	
	var num1 = vector_from[0] * throw[0]
	var num2 = vector_from[1] * throw[0]
	
	var delta = Vector2(num1,num2) * -1
	var knockback_vector: Vector2 = enemy_position + delta
	
	'match vector_from:
		Vector2(0,-1): ##Вверх
			str = "Вверх"
		Vector2(1,-1): #Право-Вверх
			str = "Право-Вверх"
		Vector2(-1,-1): #Лево-Вверх
			str = "Лево-Вверх"
		Vector2(1,0): ##Право
			str = "право"
		Vector2(-1,0): ##Лево
			str = "лево"
		Vector2(0,1): ##Низ
			str = "снизу"
		Vector2(1,1): #Право-Низ
			str = "право-низ"
		Vector2(-1,1): #Лево-Низ
			str = "лево-низ"
			
	print("____________________________")
	print("Удар пришелся:   ",str)
	debprint("player_pos    ",player_position)
	debprint("enemy_position",enemy_position)
	debprint("новый вектор  ",knockback_vector)
	debprint("delta         ",delta)
	debprint("vector        ", Vector2(snapped(dir[0],1),snapped(dir[1],1)))
	print("____________________________")'
	
	return knockback_vector
	
	
	
func debprint(first,second):
	print(first,": ",second)
	#debprint("",)
	
###############states######################

func state_switcher(object: String,in_or_out: String):

	match in_or_out:
		"in":
			match object:
				"player":
					attack_area = true
				"hands":
					damage_area = true
				"pursuit":
					state = PURSUIT
				_:
					pass
		"out":
			match object:
				"player":
					attack_area = false
				"hands":
					damage_area = false
				"pursuit":
					state = PATROL
				_:
					pass
	#print(state)

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
	

#################states########################
func death():
	animation("death")
	if enemy_animation.get_frame() == 3:
		global.player_indicators("coin", 1, "set")	
		$".".queue_free()


func attack():
	#print("атака")
	cooldown_timer.start(cooldown_time)
	global.player_damage("damage",attack_strange,"set")
	global.player_damage("damage_throw",attack_throw,"set")

	
func damage():
	var incoming_damage = global.player_attack("damage", 0, "get")
	var incoming_damage_throw = global.player_attack("damage_throw", 0, "get")
	GSet_health(GSet_health(0,GET) - incoming_damage,SET)
	damage_final_vector = damage_vector()
	animation("damage")
	if debug_freeze == true:
		state = IDLE
	else:
		state = PURSUIT


###############connections######################		



func PursuitArea_enter(body):
	if str(body.name) == "player":
		state_switcher("pursuit","in")
		player = body
		print(body.name + " enter_enemy_col - skeleton_script")

func PursuitArea_exit(body):
	if str(body.name) == "player":
		state_switcher("pursuit","out")
		player = null
		print(body.name + " exit_enemy_col - skeleton_script")

func AttackArea_enter(body):
	if str(body.name) == "player":
		state_switcher(body.name,"in")
		print(body.name + " attack_area_in - skeleton_script")

func AttackArea_exit(body):
	if str(body.name) == "player":
		state_switcher(body.name,"out")
		print(body.name + " attack_area_out - skeleton_script")
		
func DamageArea_enter(area):
	if str(area.name) == "hands":
		state_switcher("hands","in")
		print(area.name + " damage_area_in - skeleton_script")

func DamageArea_exit(area):
	if str(area.name) == "hands":
		state_switcher("hands","out")
		print(area.name + " damage_area_out - skeleton_script")

