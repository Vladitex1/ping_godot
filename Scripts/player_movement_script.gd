extends CharacterBody2D

static var speed:int = 120
static var sprint:int = 50

static var MaxHealth:float = 100
static var StarterHealth:float = 100
static var MaxStamina:int = 1000
static var StarterStamina:int = 1000
static var StaterKeys:int = 0
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

var event_monitor
var attack_zone_ready: bool = false
@onready var hands = $Hands
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
	$Hands.connect("area_entered",attack_control_on)
	$Hands.connect("area_exited",attack_control_off)
	global.PlayerStamina = StarterStamina
	global.MaxStamina = MaxStamina
	global.MaxHealth = MaxHealth
	global.PlayerHealth = StarterHealth
	global.PlayerCoins = StaterCoins	
	global.PlayerKeys = StaterKeys
	
	
	
func attack_control_on(area):
	if str(area.name) == "enemy_damage_area":
		#print("+++++++++++++++++++++++++++++++++++++")
		#print(area.get_parent().get_parent().name)
		#print(enemy_max)
		#print(enemy_list)
		for i in enemy_max:
			#print("id == "+str(i))
			if enemy_list[i][2] == str(area.get_parent().get_parent().name):
				enemy_id = enemy_list[i][0]
				#print(enemy_id)
				#print("существо: "+str(enemy_list[i][0]))
		print("в зоне атаки по существу: "+str(enemy_id))
		attack_zone_ready = true

func attack_control_off(area):
	if str(area.name) == "enemy_damage_area":
		print("не в зоне атаки")
		attack_zone_ready = false
		enemy_id = -1
		
	
func _input(event):
		event_monitor = event
		
func _physics_process(_delta):
	if console.teleport_tougle == true:
		console.teleport_tougle = false
		player.set_global_position(global.get_player_pos())
	
	
	#print(enemy_id)
	get_input()
	state_switcher()
	update_player_position(event_monitor)
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
	if global.get_tougle(3) == true and global.get_tougle(2) != true:
		Interactive.set_visible(true)
	else:
		Interactive.set_visible(false)
	if global.get_tougle(2) == true:
		loading_animation.play()
		loading_animation.set_visible(true)

	else:
		loading_animation.set_visible(false)
		loading_animation.stop()
		
func damage_texture_func(): ##заглушка
	if global.get_tougle(4) == true:
		damage_texture.show()
	else:
		damage_texture.hide()	
	
func state_switcher():	
	if Input.is_anything_pressed():
		state = WALK
	else:
		state = IDLE
	if global.PlayerIndicators("HP",0,"GET") < 0:
		state = DEATH
			
func get_input():
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if Input.is_action_pressed("move_shift"):
		if global.PlayerIndicators("STAMINA",0,"GET") > 0:
			global.PlayerIndicators("STAMINA",StaminaSpeed*-1,"SET")
			sprint	= temp_sprit
		else:
			sprint = 0
	else:
		sprint = 0
		if global.PlayerIndicators("STAMINA",0,"GET") < 0:
			global.PlayerStamina = 0
		elif global.PlayerIndicators("STAMINA",0,"GET") < MaxStamina:
			global.PlayerIndicators("STAMINA",StaminaSpeed,"SET")
	velocity = input_dir * (speed + sprint)

	if Input.is_action_just_pressed("debug1"):
		
		global.PlayerIndicators("KEYS", 1, "SET")	
	
	elif Input.is_action_just_released("special_back"):
		global.add_scene("stop_screen")

			
	else:
		state = temp_state
		global.attack_tougle = false
		global.player_attack("DAMAGE",0,"SET",enemy_id)
		global.player_attack("DAMAGE_THROW",0,"SET",enemy_id)

	
func attack():
	global.player_attack("DAMAGE",Attack_Value,"SET",enemy_id)
	global.player_attack("DAMAGE_THROW",Attack_Throw,"SET",enemy_id)	
	
		
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
			if global.PlayerIndicators("STAMINA",0,"GET") > 0:
				global.PlayerIndicators("STAMINA",AttackStaminaSpeed*-1,"SET")
				if global.attack_block == false and attack_zone_ready == true: #Атака игроком другого существа
					cooldown_timer.start(0.7)
					attack()
					global.attack_tougle = true
			
				if player_align == "right":
					player_animation.flip_h = false 
				elif player_align == "left":
					player_animation.flip_h = true
				player_animation.play("attack")
				lastanim = "attack"
			
			
			
		elif Input.is_anything_pressed() == false:
			if lastanim == "attack":
				player_animation.play("attack")
				if player_animation.get_frame() == 4:
					lastanim = "idle"
			else:
				player_animation.play("idle")
				player_animation.flip_h = false
			

func hands_control():
	hands.rotation = get_local_mouse_position().angle()
	
func update_player_position(event):
	global.set_player_pos(player.get_global_position())
	var align = player.get_global_position()-get_global_mouse_position()
	
	if align[0] >= 0:
		player_align = "left"
	else:
		player_align = "right"
		





