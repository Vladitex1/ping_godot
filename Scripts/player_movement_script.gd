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

var player_align: String
var attack_state: bool = false
var lastanim: String
@onready var player_animation = $Ping_Aimation
@onready var player = $"."
@onready var damage_texture = $Damage
@onready var loading_animation = $"Waiting_Animation"
@onready var Interactive = $Interactive
@onready var attack_timer = $AttackTimer
@onready var cooldown_timer = $CooldownTimer

@onready var hands = $Hands
@onready var weapon = $Weapon
@onready var camera2 = $Camera2D
var temp_state

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
	global.hud_load()
	global.PlayerStamina = StarterStamina
	global.MaxStamina = MaxStamina
	global.MaxHealth = MaxHealth
	global.PlayerHealth = StarterHealth
	global.PlayerCoins = StaterCoins	
	global.PlayerKeys = StaterKeys
	
	global.player_attack("damage",Attack_Value,"set")
	global.player_attack("damage_throw",Attack_Throw,"set")
	
		
func _physics_process(_delta):
	get_input()
	debug_buttons()
	
	
	update_player_position()
	state_switcher()
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
	if Input.is_action_pressed("special_shift"):
		if global.PlayerIndicators("stamina",0,"get") >= 100:
			global.PlayerIndicators("stamina",StaminaSpeed*-1,"get")
			sprint	= temp_sprit
		else:
			sprint = 0
	elif !Input.is_action_pressed("special_shift"):
		sprint = 0
		if global.PlayerIndicators("stamina",0,"get") < 0:
			global.PlayerStamina = 0
		elif global.PlayerIndicators("stamina",0,"get") < MaxStamina:
			global.PlayerIndicators("stamina",StaminaSpeed,"set")
	
	if Input.is_action_just_released("special_back"):
		global.add_scene("stop_screen")
	else:
		state = temp_state
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * (speed + sprint)
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

		elif Input.is_action_just_pressed("attack") and global.attack_block == false and cooldown_timer.is_stopped():
			if global.PlayerIndicators("stamina",0,"get") >= 200:
				
				if global.attack_block == false: #Атака игроком другого существа
					match player_align:
						"right":
							player_animation.flip_h = false 
						"left":
							player_animation.flip_h = true
					player_animation.play("attack")
					
					cooldown_timer.start(0.8)
					hands.get_child(0).disabled = false ##непосредственно атака
					global.PlayerIndicators("stamina",AttackStaminaSpeed*-1,"set")
				
				lastanim = "attack"
			
			
			
		elif Input.is_anything_pressed() == false:
			player_animation.flip_h = false
			hands.get_child(0).disabled = true
			if lastanim == "attack":
				player_animation.play("attack")
				if player_animation.get_frame() == 4:
					lastanim = "idle"
			else:
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
		global.PlayerIndicators("key", 1, "set")


		
	if Input.is_action_just_released("debug2"):
		var node = $"/root/main".get_child(1)
		var Spawn = load("res://Scenes/mobs/skeleton_mob.tscn").instantiate()
		Spawn.position = get_global_mouse_position()
		node.add_child(Spawn)


