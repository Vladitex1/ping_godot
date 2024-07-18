extends CharacterBody2D


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
var Attack_Throw: int = 100

var enemy_attack_strange = 0
var enemy_attack_throw = 0
var incoming_damage_vector
static var temp_sprit = sprint
var hoodload = true
var delta
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
@onready var damage_area = $damage_zone_detection
@onready var hands = $Hands
@onready var weapon = $Weapon
@onready var camera2 = $Camera2D
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
	state = WALK
	global.PlayerStamina = StarterStamina
	global.MaxStamina = MaxStamina
	global.MaxHealth = MaxHealth
	global.PlayerHealth = StarterHealth
	global.PlayerCoins = StaterCoins	
	global.PlayerKeys = StaterKeys
	global.player_attack("damage",Attack_Value,"set")
	global.player_attack("damage_throw",Attack_Throw,"set")
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
	#state_switcher()
	#print(enemy_attack_strange)
	
	match state:
		WALK:
			global.heat_tougle = false
			move_and_slide()
			animation(true)
			temp_state = WALK
		IDLE:
			animation(true)
			temp_state = IDLE
		DAMAGE:
			player_animation.flip_h = false 
			if player_align == "left":
				player_animation.flip_h = true
			move(incoming_damage_vector,_delta,200)#0.6
			player_animation.play("damage")
			await get_tree().create_timer(0.3).timeout
			print("получение урона - player_movement_script")
			if damage_ready == true:
				damage_ready = false
				global.PlayerIndicators("hp",enemy_attack_strange,"set")
			state = temp_state
		DEATH:
			pass
	
	hands_control()
	interactive()


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
		
		
		
	
func state_switcher():	
	if Input.is_anything_pressed():
		state = WALK
	else:
		state = IDLE
	#if global.PlayerIndicators("hp",0,"get") < 0:
		#state = DEATH
			
func get_input():
	if Input.is_action_pressed("special_shift"):
		if global.PlayerIndicators("stamina",0,"get") < 0:
			sprint = 0
		elif global.PlayerIndicators("stamina",0,"get") <= 1000:
			global.PlayerIndicators("stamina",StaminaSpeed*-1,"set")
			sprint = temp_sprit

	elif !Input.is_action_pressed("special_shift"):
		sprint = 0
		if global.PlayerIndicators("stamina",0,"get") < 0:
			global.PlayerStamina = 0
		elif global.PlayerIndicators("stamina",0,"get") < MaxStamina:
			global.PlayerIndicators("stamina",StaminaSpeed,"set")
	
	if Input.is_action_just_released("special_back"):
		global.add_scene("stop_screen")
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * (speed + sprint)
	
func animation(is_pressing: bool):

	if is_pressing:
		if Input.is_action_pressed("move_right"):
			player_animation.flip_h = false
			player_animation.play("walk_right")
			lastanim = "walk_right"
			
		elif Input.is_action_pressed("move_left"):
			player_animation.flip_h = true
			player_animation.play("walk_right")
			lastanim = "walk_right"

		elif Input.is_action_pressed("move_up"):
			player_animation.play("walk_up")
			lastanim = "walk_up"

		elif Input.is_action_pressed("move_down"):
			player_animation.play("walk_down")
			lastanim = "walk_down"

		elif Input.is_action_pressed("attack") and global.attack_block == false and cooldown_timer.is_stopped():
			if global.PlayerIndicators("stamina",0,"get") >= 200:
				
				if global.attack_block == false: #Атака игроком другого существа
					player_animation.flip_h = false 
					if player_align == "left":
						player_animation.flip_h = true
					player_animation.play("attack")
					
					cooldown_timer.start(0.8)
					hands.get_child(0).disabled = false ##непосредственно атака
					global.PlayerIndicators("stamina",AttackStaminaSpeed*-1,"set")
				
				lastanim = "attack"
			
			
			
		elif Input.is_anything_pressed() == false:
			hands.get_child(0).disabled = true
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
		global.PlayerIndicators("key", 1, "set")

	if Input.is_action_just_released("debug2"):
		var node = $"../..".get_child(1)
		var Spawn = load("res://Scenes/mobs/skeleton_mob.tscn").instantiate()
		Spawn.position = get_global_mouse_position()
		node.add_child(Spawn)


##########DAMAGE###################
	
func damage_vector(area):# -> Vector2:
	var player_position = player.global_position
	var enemy_position = area.global_position
	var knockback_distance = enemy_attack_throw  # Установите нужное значение расстояния
	var knockback_force = enemy_attack_strange  # Сила удара
	var direction: Vector2 = (player_position - enemy_position).normalized()
	var knockback_vector: Vector2 = player_position + direction * knockback_distance * knockback_force
	return knockback_vector	
	
func move(target, _delta, spd):
	var direction = velocity + target
	velocity = velocity.lerp(direction.normalized() * speed, acceleration * _delta) 
	move_and_slide()
	

###########AREAS############
func damage_area_enter(area):
	if str(area.name) == "enemy_hands":
		enemy_attack_strange = area.get_parent().attack_strange
		enemy_attack_throw = area.get_parent().attack_throw
		incoming_damage_vector = damage_vector(area)
		temp_state = state
		state = DAMAGE
		damage_ready = true
		
func damage_area_exit(area):
	if str(area.name) == "enemy_hands":
		state = temp_state

