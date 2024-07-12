extends CharacterBody2D

static var speed:int = 120
static var sprint:int = 50

static var MaxHealth:int = 100
static var StarterHealth:int = 100
static var MaxStamina:int = 1000
static var StarterStamina:int = 1000
static var StaterKeys:int = 5
static var StaterCoins:int = 0

static var StaminaSpeed: int = 2
static var AttackStaminaSpeed: int = 100
var Attack_Value: int = 25
var Attack_Throw: int = 20

static var temp_sprit = sprint
var delta = 1
var is_first_try = true
var player_align: String
var attack_state: bool = false
@onready var player_animation = $Ping_Aimation
@onready var player = $"."
@onready var damage_texture = $Damage
@onready var loading_animation = $"Waiting_Animation"
@onready var Interactive = $Interactive
@onready var attack_timer = $AttackTimer
@onready var cooldown_timer = $CooldownTimer
var attack_zone_ready: bool = false
@onready var hands = $Hands
@onready var weapon = $Weapon
@onready var camera2 = $Camera2D
var attack_cooldown = true
var temp_state
var enemy_id
var enemy_max: int

var enemy_list = {}
enum {
	IDLE,
	WALK,
	DEATH,
	GET,
	SET,
	ATTACK,
	}

var state = IDLE

func _ready():
	
	global.PlayerStamina = StarterStamina
	global.MaxStamina = MaxStamina
	global.MaxHealth = MaxHealth
	global.PlayerHealth = StarterHealth
	global.PlayerCoins = StaterCoins	
	global.PlayerKeys = StaterKeys
	
	global.player_attack("damage",Attack_Value,"set")
	global.player_attack("damage_throw",Attack_Throw,"set")
	
		
func _physics_process(_delta):
	if console.teleport_tougle == true:
		console.teleport_tougle = false
		player.set_global_position(global.get_player_pos())
	
	get_input()
	state_switcher()
	update_player_position()
	match state:
		WALK:
			move_and_slide()
			animation(true)
		IDLE:
			animation(true)
		DEATH:
			pass
			
			
	hands_control()
	interactive()
	damage_texture_func()
	
	




func interactive():
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
		
func damage_texture_func(): ##заглушка
	if global.heat_tougle:
		damage_texture.show()
	else:
		damage_texture.hide()	
	
func state_switcher():	
	if Input.is_anything_pressed():
		state = WALK
	else:
		state = IDLE
	#if global.PlayerIndicators("hp",0,"get") < 0:
		#state = DEATH
			
func get_input():
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if Input.is_action_pressed("special_shift"):
		if global.PlayerIndicators("stamina",0,"get") >= 100:
			global.PlayerIndicators("stamina",StaminaSpeed*-1,"get")
			sprint	= temp_sprit
		else:
			sprint = 0
	else:
		sprint = 0
		if global.PlayerIndicators("stamina",0,"get") < 0:
			global.PlayerStamina = 0
		elif global.PlayerIndicators("stamina",0,"get") < MaxStamina:
			global.PlayerIndicators("stamina",StaminaSpeed,"set")
	velocity = input_dir * (speed + sprint)

	if Input.is_action_just_pressed("debug1"):
		
		global.PlayerIndicators("key", 1, "set")	
	
	elif Input.is_action_just_released("special_back"):
		global.add_scene("stop_screen")
	
	else:
		state = temp_state
		
		
var animnum = 0
var lastanim
func animation(is_pressing: bool):
	if is_pressing:
		if Input.is_action_pressed("move_right"):
			player_animation.flip_h = false
			player_animation.play("walk_right")
			
		elif Input.is_action_pressed("move_left"):
			player_animation.flip_h = true
			player_animation.play("walk_right")

		elif Input.is_action_pressed("move_up"):
			player_animation.play("walk_up")

		elif Input.is_action_pressed("move_down"):
			player_animation.play("walk_down")

		elif Input.is_action_just_pressed("attack") and global.attack_block == false and cooldown_timer.is_stopped() :
			#velocity = Vector2(0,0)
			if global.PlayerIndicators("stamina",0,"get") >= 200:
				hands.get_child(0).disabled = false
				global.PlayerIndicators("stamina",AttackStaminaSpeed*-1,"set")
				if global.attack_block == false and attack_zone_ready == true: #Атака игроком другого существа
					cooldown_timer.start(0.7)
					
					global.attack_tougle = true
			
				if player_align == "right":
					player_animation.flip_h = false 
				elif player_align == "left":
					player_animation.flip_h = true
				player_animation.play("attack")
				lastanim = "attack"
			
			
			
		elif Input.is_anything_pressed() == false:
			hands.get_child(0).disabled = true
			if lastanim == "attack":
				player_animation.play("attack")
				if player_animation.get_frame() == 4:
					lastanim = "idle"
			else:
				player_animation.play("idle")
				player_animation.flip_h = false
			

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
		





