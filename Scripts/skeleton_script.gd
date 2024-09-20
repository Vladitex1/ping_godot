extends CharacterBody2D

@export var list_num: int

@onready var detectiron_area = $detection
@onready var attack_timer = $AttackTimer
@onready var cooldown_timer = $CooldownTimer
@onready var enemy_animation = $AnimatedSprite2D
@onready var health_bar = $health_bar
@onready var health_progress_bar = $health_bar/health_bar
@onready var health_count_label = $health_bar/healh_count_label
@onready var nav: NavigationAgent2D = $NavigationAgent2D


enum State {
	PATROL,
	PURSUIT,
	ATTACK,
	DAMAGE,
	DEATH,
	IDLE
}

var animations: Dictionary = {
"walk": 
	{
		"right": "skeleton_walk_side",
		"left": "skeleton_walk_side",
		"up": "skeleton_walk_up",
		"down": "skeleton_walk_down"
	},
"idle": 
	{
		"right": "skeleton_idle_side",
		"left": "skeleton_idle_side",
		"up": "skeleton_idle_up",
		"down": "skeleton_idle_down"
	},
"damage": 
	{
		"right": "skeleton_damage_side",
		"left": "skeleton_damage_side",
		"up": "skeleton_damage_up",
		"down": "skeleton_damage_down"
	},
"death": 
	{
		"right": "skeleton_death_side",
		"left": "skeleton_death_side",
		"up": "skeleton_death_up",
		"down": "skeleton_death_down"
	}
}

var direction_str: String
var current_checkpoint = 0
const STANDARD_SPEED: float = 100
const MAX_HEALTH: int = 150
const COOLDOWN_ATTACK: float = 1
const COOLDOWN_TIME: float = 1
const ACCELERATION = 5
const DEBUG_FREEZE = false
var last_movement: String
var attack_area: bool = false
var damage_area: bool = false
var attack_strength: int = 5
var attack_throw: int = 15
var health_value: int
var speed: float
var state = State.IDLE
var player: Node2D = null
var direction = Vector2()
var target_position: Vector2
var is_in_pursuit = true

func _ready():
	cooldown_timer.start(0.001)
	attack_timer.start(0.001)
	health_value = MAX_HEALTH
	health_progress_bar.max_value = MAX_HEALTH
	health_bar.visible = false
	target_position = get_circle_position()
	
	$enemy_hands.connect("body_entered", AttackArea_enter)
	$enemy_hands.connect("body_exited", AttackArea_exit)

	detectiron_area.connect("body_entered", PursuitArea_enter)
	detectiron_area.connect("body_exited", PursuitArea_exit)

	$damage_area.connect("area_entered", DamageArea_enter)
	$damage_area.connect("area_exited", DamageArea_exit)

func _physics_process(_delta) -> void:
	healh_control()
	health_bar_control()
	if attack_area and state != State.DAMAGE:
		attack()
	if damage_area and global.player_attack("damage", 0, "get") > 0:
		if global.player_attack("damage_throw", 0, "get") > 0:
			cooldown_timer.start(global.player_attack("damage_throw", 0, "get") * 0.01) ##отбрасывание
			damage(global.player_attack("damage", 0, "get"))
			state = State.DAMAGE
	else:
		match state:
			State.PATROL:
				speed = STANDARD_SPEED/2
				if global_position.distance_to(target_position) < 20:
					cooldown_timer.start(3)
					target_position = get_circle_position()
					state = State.IDLE
				detectiron_area.look_at(nav.get_next_path_position())
				animation(nav.get_next_path_position(),"walk")
				move(target_position, speed)
			State.PURSUIT:
				nav.target_position = global.get_player_pos()
				move(nav.get_next_path_position(),speed)
				detectiron_area.look_at(global.get_player_pos())
				if position.distance_to(nav.target_position) < 15:
					speed = -1
					animation(nav.get_next_path_position(),"idle")
				else:
					speed = STANDARD_SPEED
					animation(nav.get_next_path_position(),"walk")
				if DEBUG_FREEZE:
					state = State.IDLE
			State.DAMAGE:
				if is_in_pursuit:
					target_position = global.get_player_pos()
					animation(target_position,"damage")
					is_in_pursuit = false
					speed = STANDARD_SPEED
				else:
					if cooldown_timer.time_left < 0.01 and health_value > 0:
						state = State.PURSUIT
						is_in_pursuit = true
					move(target_position, speed*1.5 * -1)
			State.IDLE:
				if cooldown_timer.time_left < 0.01:
					state = State.PATROL
				animation(Vector2(0,0),"idle")
			State.DEATH:
				pass
			
###############

func move(target_pos, spd) -> void:
	nav.target_position = target_pos
	var direction = to_local(nav.get_next_path_position()).normalized()
	velocity = direction * spd
	if position.distance_to(target_pos) > 20:
		move_and_slide()
		
func animation(to_position,condition) -> void:
	var dir = rad_to_deg((to_position - global_position).angle())
	
	if dir <= 45 and dir >= -45:
		direction_str = "right"
		enemy_animation.flip_h = false
	elif dir <= -135 or dir >= 135:
		direction_str = "left"
		enemy_animation.flip_h = true
	elif dir >= -135 and dir <= -45:
		direction_str = "up"
	elif dir <= 135 and dir >= 45:
		direction_str = "down"
	if condition in animations and direction_str in animations[condition]:
		enemy_animation.play(animations[condition][direction_str])
	last_movement = direction_str
	 
###############health_bar_conrol######################

func healh_control() -> void:
	if health_value < 1:
		health_value = 0
		damage_area = false
		animation(target_position,"death")
		speed = 1
		state = State.DEATH
		if enemy_animation.get_frame() == 3:
			death()
	

func health_bar_control() -> void:
	health_count_label.text = str(health_value)
	health_progress_bar.value = health_value
	
	if health_value < 1 or health_value == MAX_HEALTH:
		health_bar.visible = false
	else:
		health_bar.visible = true

###############states######################

func state_switcher(object: String, in_or_out: String):
	match in_or_out:
		"in":
			match object:
				"player":
					attack_area = true
				"hands":
					damage_area = true
				"pursuit":
					state = State.PURSUIT
		"out":
			match object:
				"player":
					attack_area = false
				"hands":
					damage_area = false
				"pursuit":
					state = State.PATROL

###############patrol######################

func get_circle_position():
	var node = $".".get_parent().get_parent()
	var node1 = node.get_child(0).get_child(3)
	#print(node1.position_list)
	if !node1.position_list.has(list_num):
		list_num = 0
	if current_checkpoint == len(node1.position_list)-1:
		current_checkpoint = 0
	else:
		current_checkpoint += 1
	var naem = node1.position_list[list_num][current_checkpoint]
	var Vector: Vector2 = Vector2(naem[0],naem[1])
	return Vector
	
	
	
	'	#print(naem)
	var max = 30
	var min = -30
	var randnum1 = randi_range(min, max)
	var randnum2 = randi_range(min, max)
	var num = Vector2(cos(randnum1), sin(randnum2)) * 100
	#var Vector:Vector2 = global_position + num '
	
#################states########################

func death():
	loot_drop(2)
	$".".queue_free()

func loot_drop(item:int):
	var spawn = load("res://Scenes/objects/dynamic_loot.tscn").instantiate()
	spawn.position = global_position
	var node = $"../..".get_child(3)
	spawn.item = 2
	#print(node)
	#print(spawn.item)
	
	node.add_child(spawn)

func attack():
	if attack_timer.time_left < 0.1:
		global.player_damage("damage", attack_strength, "set")
		global.player_damage("damage_throw", attack_throw, "set")
		attack_timer.start(COOLDOWN_ATTACK)
	else:
		global.player_damage("damage", 0, "set")
		global.player_damage("damage_throw", 0, "set")

func damage(damage_strength):
	health_value -= damage_strength
	animation(global.get_player_pos(),"damage")
	state = State.PURSUIT

###############connections######################		

func PursuitArea_enter(body):
	if str(body.name) == "player":
		state_switcher("pursuit", "in")
		player = body

func PursuitArea_exit(body):
	if str(body.name) == "player":
		state_switcher("pursuit", "out")
		player = null

func AttackArea_enter(body):
	if str(body.name) == "player":
		state_switcher(body.name, "in")

func AttackArea_exit(body):
	if str(body.name) == "player":
		state_switcher(body.name, "out")

func DamageArea_enter(area):
	if str(area.name) == "hands":
		state_switcher("hands", "in")

func DamageArea_exit(area):
	if str(area.name) == "hands":
		state_switcher("hands", "out")
