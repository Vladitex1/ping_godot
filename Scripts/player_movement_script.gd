extends CharacterBody2D

static var speed: int = 120
static var sprint: int = 50
static var max_health: int = 100
static var max_stamina: int = 1000
const attack_strength: int = 25
const attack_throw: int = 15

static var starter_health: int = max_health
static var starter_stamina: int = max_stamina
static var starter_keys: int = 5
static var starter_coins: int = 0

static var temp_attack_strength: int = 0
static var temp_attack_throw: int = 0

const weapon = 0

var stmn_state = Stamina_State.HOLD
var atck_state = Attack_State.HOLD
const stamina_cost_speed: int = 3
var stamina_recovery_speed: int = 2
var temp_stamina_recovery_speed = stamina_recovery_speed/2
var recovery_speed: int = stamina_recovery_speed
const attack_stamina_cost: int = 150
const stamina_cooldown_limit: int = 200
const cooldown_attack: float = 0.5

static var temp_sprint = sprint


var anim_attack_block: bool = false
var hud_loaded: bool = true
var player_align: String
var last_anim: String
var damage_active: bool = false
var ift: bool = true
var current_area = null
var attack_ift: bool = true

@onready var player_animation = $Ping_Animation
@onready var player = $"."
@onready var loading_animation = $"Waiting_Animation"
@onready var interactive = $Interactive
@onready var cooldown_damage_timer = $Cooldown_Damage_Timer
@onready var attack_timer = $Attack_Timer
@onready var damage_area = $Damage_Zone_Detection
@onready var hands = $hands
@onready var weapon_icon = $Weapon
@onready var camera2 = $Camera2D
@onready var nav = $NavigationAgent2D
@onready var attack_animation = $Weapon/Attack_Animation
var damage_ready
var temp_pos: Vector2

enum State {
	IDLE,
	WALK,
	DEATH,
	GET,
	SET,
	ATTACK,
	DAMAGE,
}


enum Attack_State {
	ATTACK,
	COOLDOWNZERO,
	COOLDOWN,
	HOLD,
}

enum Stamina_State {
	RUN,
	COOLDOWN,
	HOLD,
}


var state = State.WALK
var temp_state = State.WALK

func _ready():
	# Инициализация глобальных переменных
	if weapon == 1:
		weapon_icon.visible = true
		
	attack_timer.start(0.001)
	global.stamina_limit = stamina_cooldown_limit
	global.player_stamina = starter_stamina
	global.max_stamina = max_stamina
	global.max_health = max_health
	global.player_health = starter_health
	global.player_coins = starter_coins
	global.player_keys = starter_keys

	temp_attack_strength = attack_strength
	temp_attack_throw = attack_throw

	damage_area.connect("area_entered", damage_area_enter)
	damage_area.connect("area_exited", damage_area_exit)

func hud_load():
	if hud_loaded:
		hud_loaded = false
		global.hud_load()
		get_viewport().position = Vector2i(0,0)
		get_viewport().size = DisplayServer.screen_get_size()

func _physics_process(_delta):
	
	hud_load()
	get_input()
	debug_buttons()
	
	state_switcher()
	movement()
	attack()	
	#print(global.player_attack("damage", attack_strength, "get"))
	#print(attack_timer.time_left)
	#print("______________")
	
	match state:
		State.IDLE:
			animation("idle")
		State.WALK:
			animation("walk")
			move_and_slide()
		State.DAMAGE:
			if ift:
				cooldown_damage_timer.start(global.player_damage("damage_throw", 0, "get") * 0.01)
				ift = false
			else:
				move(current_area, speed * 2 * -1)
				if cooldown_damage_timer.time_left < 0.1:
					state = State.WALK
					ift = true

	hands_control()
	interactive_control()

func move(target, spd):

	velocity = position.direction_to(target) * spd
	if position.distance_to(target) > 10:
		move_and_slide()
		return false
	else:
		return true

func interactive_control():
	if global.action_toggle and not global.loading_toggle:
		interactive.set_visible(true)
	else:
		interactive.set_visible(false)
	if global.loading_toggle:
		loading_animation.play()
		loading_animation.set_visible(true)
	else:
		loading_animation.set_visible(false)
		loading_animation.stop()

func damage(dmg: int):
	animation("damage")
	global.player_indicators("hp", dmg * -1, "set")
	state = State.DAMAGE

func attack():
	

	
	var input: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	match atck_state:
		Attack_State.ATTACK:
			animation("attack")
			if global.player_indicators("stamina", 0, "get") <= 50:
				atck_state = Attack_State.COOLDOWNZERO
			else:
				atck_state = Attack_State.COOLDOWN
			
				
		Attack_State.COOLDOWNZERO:
			attack_timer.start(cooldown_attack)
			if global.player_indicators("stamina", 0, "get") >= stamina_cooldown_limit:
				recovery_speed = stamina_recovery_speed
				atck_state = Attack_State.COOLDOWN
			else:
				recovery_speed = temp_stamina_recovery_speed
		Attack_State.COOLDOWN:
			attack_timer.start(cooldown_attack)
			atck_state = Attack_State.HOLD
		Attack_State.HOLD:
			if Input.is_action_pressed("attack"):
				if !global.attack_block:
					if attack_timer.time_left == 0 and input == Vector2(0,0): 
						atck_state = Attack_State.ATTACK
		
	if atck_state == Attack_State.ATTACK:
		global.player_attack("damage", attack_strength, "set")
		global.player_attack("damage_throw", attack_throw, "set")
		global.player_indicators("stamina", attack_stamina_cost * -1, "set")
	else:
		global.player_attack("damage", 0, "set")
		global.player_attack("damage_throw", 0, "set")

func death():
	global.player_indicators("hp", max_health, "set")

func state_switcher():
	if damage_active and global.player_damage("damage", 0, "get") > 0:
		damage(global.player_damage("damage", 0, "get"))
		state = State.DAMAGE

	if global.player_indicators("hp", 0, "get") < 0:
		death()
			
func movement():
	var stmn = global.player_stamina
	var input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	match stmn_state:
		Stamina_State.RUN:
			if stmn == 0:
				stmn_state = Stamina_State.COOLDOWN
			if stmn != 0 and Input.is_action_just_released("special_shift"):
				stmn_state = Stamina_State.HOLD
		Stamina_State.COOLDOWN:
			if stmn >= stamina_cooldown_limit:
				stmn_state = Stamina_State.HOLD
		Stamina_State.HOLD:
			if Input.is_action_pressed("special_shift") and input != Vector2(0,0):
				stmn_state = Stamina_State.RUN
	
	if stmn_state == Stamina_State.RUN:
		sprint = temp_sprint
		global.player_indicators("stamina", stamina_cost_speed * -1, "set")
	else:
		sprint = 0
		global.player_indicators("stamina", recovery_speed, "set")
	
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * (speed + sprint)
				
func get_input():
	if Input.is_action_just_released("special_back"):
		global.add_scene("stop_screen")


func animation(anim: String) -> void:
	update_player_position()
	
	match anim:
		"attack":
			match weapon:
				0:
					player_animation.play("attack")
				_:
					match player_align:
						"left":
							attack_animation.play("attack_left")
						"right":
							attack_animation.play("attack_right")	
			last_anim = anim
		"damage":
			player_animation.play("damage")
			last_anim = "damage"
		_:
			if cooldown_damage_timer.time_left < 0.1:
				match Input.get_vector("move_left", "move_right", "move_up", "move_down"):
					Vector2(1, 0):  # Право
						player_animation.play("walk_right")
						player_align = "right"
						last_anim = "walk_right"
					Vector2(-1, 0):  # Лево
						player_animation.play("walk_right")
						player_align = "left"
						last_anim = "walk_right"
					Vector2(0, -1):  # Вверх
						player_animation.play("walk_up")
						last_anim = "walk_up"
					Vector2(0, 1):  # Вниз
						player_animation.play("walk_down")
						last_anim = "walk_down"
					Vector2(0, 0):
						if last_anim == "attack" and weapon == 0:
							match weapon:
								0:													
									if player_animation.frame == 4:
										player_animation.play("idle")
								_:
									attack_animation.stop()
									last_anim = "idle"
						elif last_anim != "attack":
							player_animation.play("idle")
							


func hands_control():
	hands.rotation = get_local_mouse_position().angle()

func update_player_position():
	global.set_player_pos(global_position)
	var align = player.get_global_position() - get_global_mouse_position()
	if align[0] >= 0:
		player_align = "left"
		player_animation.flip_h = true
	else:
		player_align = "right"
		player_animation.flip_h = false

func debug_buttons():
	
	if Input.is_action_just_pressed("debug1"):
		global.player_indicators("key", 1, "set")

	if Input.is_action_just_released("debug2"):
		var node = $"../..".get_child(1)
		var spawn = load("res://Scenes/mobs/skeleton_mob.tscn").instantiate()
		spawn.position = get_global_mouse_position()
		node.add_child(spawn)

func damage_area_enter(area):
	if str(area.name) == "enemy_hands":
		current_area = area.global_position
		damage_active = true

func damage_area_exit(area):
	if str(area.name) == "enemy_hands":
		damage_active = false
