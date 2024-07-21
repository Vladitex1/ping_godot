extends CharacterBody2D

var current_area = null
const Null: int = 0
static var acceleration:int = 5
static var speed:int = 120
static var sprint:int = 50

static var MaxHealth:int = 100
static var StarterHealth:int = 100
static var MaxStamina:int = 1000
static var StarterStamina:int = 1000
static var StaterKeys:int = 5
static var StaterCoins:int = 0

static var StaminaSpeed: int = 5
static var AttackStaminaSpeed: int = 100
var Attack_Value: int = 25
var Attack_Throw: int = 30#1.1
static var cooldown_attack: float = 0.8
var enemy_attack_strange = 0
var enemy_attack_throw = 0
var incoming_damage_vector
static var temp_sprit = sprint
var hoodload = true
var delta
var player_align: String
var attack_state: bool = false
var lastanim: String
var damage_active: bool
@onready var player_animation = $Ping_Aimation
@onready var player = $"."
@onready var loading_animation = $"Waiting_Animation"
@onready var Interactive = $Interactive
@onready var cooldown_damage_timer = $cooldown_damage_timer
@onready var cooldown_timer = $CooldownTimer
@onready var damage_area = $damage_zone_detection
@onready var hands = $hands
@onready var weapon = $Weapon
@onready var camera2 = $Camera2D
@onready var nav: NavigationAgent2D = $NavigationAgent2D
var damage_ready

enum {
	IDLE,
	WALK,
	DEATH,
	GET,
	SET,
	ATTACK,
	DAMAGE,
	}

var state = WALK
var temp_state = WALK
func _ready():
	global.PlayerStamina = StarterStamina
	global.MaxStamina = MaxStamina
	global.MaxHealth = MaxHealth
	global.PlayerHealth = StarterHealth
	global.PlayerCoins = StaterCoins	
	global.PlayerKeys = StaterKeys
	damage_area.connect("area_entered",damage_area_enter)
	damage_area.connect("area_exited",damage_area_exit)
	
func hud_load():
	if hoodload == true:
		hoodload = false
		global.hud_load()	

func _physics_process(_delta):
	hud_load()
	get_input()
	debug_buttons()
	update_player_position()
	state_switcher()
	#if global.player_damage("damage",0,"get") > 0:
		#print(damage_active)	
		#print(global.player_damage("damage",0,"get"))
	print(state)
	match state:
		WALK: #1
			animation("0")
			move_and_slide()
		IDLE: #0
			animation("0")
		DAMAGE:
			if !move(incoming_damage_vector,_delta,650):
				pass
			else:	
				state = WALK
	
	hands_control()
	interactive()

func interactive(): ##Иконка взаимодействия
	if global.action_tougle and !global.loading_tougle:
		Interactive.set_visible(true)
	else:
		Interactive.set_visible(false)
	if global.loading_tougle:
		loading_animation.play()
		loading_animation.set_visible(true)
	else:
		loading_animation.set_visible(false)
		loading_animation.stop()
		
#################states#########################
	
func damage(damage:int):	
	animation("damage")
	cooldown_damage_timer.start(0.25)
	global.player_indicators("hp",damage * -1,"set")
	
func attack():
	animation("attack")
	global.player_attack("damage",Attack_Value,"set")
	global.player_attack("damage_throw",Attack_Throw,"set")
	cooldown_timer.start(cooldown_attack)
	global.player_indicators("stamina",AttackStaminaSpeed*-1,"set")
	#hands.get_child(0).disabled = false ##непосредственно атака

func death():
	global.player_indicators("hp",MaxHealth,"set")

#############################################################################################		
		
func state_switcher():
	if global.player_indicators("hp",0,"get") < 0:
		death()
	elif global.player_damage("damage",0,"get") > 0 and damage_active:
		#print(global.player_damage("damage",0,"get"))
		incoming_damage_vector = damage_vector(current_area)
		damage(global.player_damage("damage",0,"get"))
		state = DAMAGE
	elif Input.is_action_pressed("attack") and global.attack_block == false and cooldown_timer.is_stopped() and global.player_indicators("stamina",0,"get") >= 200:
		attack()
	elif state != DAMAGE: 
		global.player_attack("damage",0,"set")
		global.player_attack("damage_throw",0,"set")
	else:
		state = WALK
		
	if !Input.is_anything_pressed():
		state = IDLE


			
func get_input():
	if Input.is_action_pressed("special_shift"):
		if global.player_indicators("stamina",0,"get") < 0:
			sprint = 0
		elif global.player_indicators("stamina",0,"get") <= 1000:
			global.player_indicators("stamina",StaminaSpeed*-1,"set")
			sprint = temp_sprit

	elif !Input.is_action_pressed("special_shift"):
		sprint = 0
		if global.player_indicators("stamina",0,"get") < 0:
			global.PlayerStamina = 0
		elif global.player_indicators("stamina",0,"get") < MaxStamina:
			global.player_indicators("stamina",StaminaSpeed,"set")
	
	if Input.is_action_just_released("special_back"):
		global.add_scene("stop_screen")
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * (speed + sprint)
	
func animation(animation: String) -> void:
	match animation:
		"attack":
			match player_align:
				"left":
					player_animation.flip_h = true
				_:
					player_animation.flip_h = false 
			player_animation.play("attack")
			lastanim = "attack"
		"damage":
			match player_align:
				"left":
					player_animation.flip_h = true
				_:
					player_animation.flip_h = false 
			player_animation.play("damage")
			lastanim = "damage"
		_:
			if cooldown_damage_timer.time_left < 0.1:
				match Input.get_vector("move_left", "move_right", "move_up", "move_down"):
					Vector2(1,0): ##Право
						player_animation.flip_h = false
						player_animation.play("walk_right")
						lastanim = "walk_right"
					Vector2(-1,0): ##Лево
						player_animation.flip_h = true
						player_animation.play("walk_right")
						lastanim = "walk_right"
					Vector2(0,-1): ##Вверх
						player_animation.play("walk_up")
						lastanim = "walk_up"
					Vector2(0,1): ##Вниз
						player_animation.play("walk_down")
						lastanim = "walk_down"
					Vector2(0,0):
						if lastanim == "attack":
							player_animation.play("attack")
							if player_animation.get_frame() == 4:
								lastanim = "idle"
						else:
							player_animation.flip_h = false
							player_animation.play("idle")

func hands_control():
	hands.rotation = get_local_mouse_position().angle()
	weapon.rotation = get_local_mouse_position().angle()
	
func update_player_position():
	global.set_player_pos(player.get_global_position())
	var align = player.get_global_position()-get_global_mouse_position()
	if align[0] >= 0:
		player_align = "left"
	else:
		player_align = "right"
		
func debug_buttons():
	if Input.is_action_just_pressed("debug1"):
		global.player_indicators("key", 1, "set")

	if Input.is_action_just_released("debug2"):
		var node = $"../..".get_child(1)
		var Spawn = load("res://Scenes/mobs/skeleton_mob.tscn").instantiate()
		Spawn.position = get_global_mouse_position()
		node.add_child(Spawn)


##########DAMAGE###################

func damage_vector(area) -> Vector2:
	var player_position = global_position
	var enemy_position = area.global_position
	var dist = global.player_damage("damage_throw",0,"get")
	var throw: Vector2 = Vector2(dist,dist)
	var dir: Vector2 = (enemy_position - player_position).normalized()
	var vector_from = Vector2(snapped(dir[0],1),snapped(dir[1],1))
	
	var num1 = vector_from[0] * throw[0]
	var num2 = vector_from[1] * throw[0]
	
	var delta = Vector2(num1,num2) * -1
	var knockback_vector: Vector2 = player_position + delta
	
	return knockback_vector	
	
	

func move(target, _delta, spd): ################################################
	#print(target)
	#print(global_position)
	nav.target_position = target
	nav.get_next_path_position()
	velocity = position.direction_to(target) * spd
	print(position.distance_to(target))
	if position.distance_to(target) > 10:
		move_and_slide()
		return false
	return true
	

###########AREAS############
func damage_area_enter(area):
	if str(area.name) == "enemy_hands":
		#print(area.name)
		enemy_attack_strange = area.get_parent().attack_strange
		enemy_attack_throw = area.get_parent().attack_throw
		current_area = area
		damage_active = true
		
func damage_area_exit(area):
	if str(area.name) == "enemy_hands":
		damage_active = false

