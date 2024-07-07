extends Node

static var scene1 = preload("res://Scenes/shop.tscn").instantiate()
static var scene2 = preload("res://Scenes/hud.tscn").instantiate()
static var scene3 = preload("res://Scenes/inventory.tscn").instantiate()
static var scene4 = preload("res://Scenes/stop_screen.tscn").instantiate()
static var scene5 = preload("res://Scenes/debug.tscn").instantiate()

static var shop_tougle:bool = false
static var action_tougle:bool = false
static var loading_tougle:bool = false
static var heat_tougle:bool = false
static var attack_tougle:bool = false
static var drag_tougle:bool = false
static var brightness:float = 1
static var ret: bool = false
static var attack_block:bool = false

static var PlayerHealth: float
static var MaxHealth: float
static var PlayerStamina: float
static var MaxStamina: float

static var PlayerKeys: int
static var PlayerCoins: int

static var Damage: int
static var Damage_Throw: int
static var current_enemy_attack_id: int
var temphp:int = PlayerHealth
var tempCoins:int = PlayerCoins
var tempKeys:int = PlayerKeys
var tempStamina:int = PlayerStamina

var ememy_id_list = {}
var enemy_id_global


var player_damage

static var player_position: Vector2
static var camera_position: Vector2
static var camera_zoom: Vector2

static var dragging:bool = false


func change_scene(name):
	get_tree().change_scene_to_file("res://Scenes/"+name+".tscn")
	
func add_scene(name):
	match name:
		"shop":
			get_tree().root.add_child(scene1)
		"hud":
			get_tree().root.add_child(scene2)
		"inventory":
			get_tree().root.add_child(scene3)
		"stop_screen":
			get_tree().root.add_child(scene4)
			
func del_scene(name):
	match name:
		"shop":
			scene1.queue_free()
			scene1 = load("res://Scenes/"+name+".tscn").instantiate()
		"hud":
			scene2.queue_free()
			scene2 = load("res://Scenes/"+name+".tscn").instantiate()
		"inventory":
			scene3.queue_free()
			scene3 = load("res://Scenes/"+name+".tscn").instantiate()
		"stop_screen":
			scene4.queue_free()
			scene4 = load("res://Scenes/"+name+".tscn").instantiate()
			
func set_tougle(num:int,status:bool):
	match num:
		1:
			shop_tougle = status
		2:
			loading_tougle = status
		3:
			action_tougle = status
		4:
			heat_tougle = status
		5: 
			drag_tougle = status
		6: 
			attack_tougle = status
			
func get_tougle(num:int):
	match num:
		1:
			ret = shop_tougle
		2:
			ret = loading_tougle
		3:
			ret = action_tougle
		4: 
			ret = heat_tougle
		5:
			ret = drag_tougle
		6: 
			ret = attack_tougle
	return ret

func hud_load():
	global.add_scene("hud")
	global.add_scene("inventory")

func set_player_pos(vector: Vector2):
	player_position = vector

func get_player_pos():
	return player_position

func set_camera_position(num,zoom):
	camera_position = num
	camera_zoom = zoom

func get_camera_position(num):
	match num:
		1:
			return camera_position
		2:
			return camera_zoom
	
func incomingPlayerDamage(name, delta, GSET, ID):
	#ememy_id_list[ID]
	match GSET:
		"SET":
			match name:
				"DAMAGE":
					Damage = delta
				"DAMAGE_THROW":
					Damage_Throw = delta
		"GET":
			match name:
				"DAMAGE":
					return Damage
				"DAMAGE_THROW":
					return Damage_Throw

func player_attack(name, delta, GSET, enemy_id):
	if enemy_id != 0:
		enemy_id_global = enemy_id

	match GSET:
		"SET":
			match name:
				"DAMAGE":
					Damage = delta
				"DAMAGE_THROW":
					Damage_Throw = delta
		"GET":
			match name:
				"DAMAGE":
					return Damage
				"DAMAGE_THROW":
					return Damage_Throw


func PlayerIndicators(name, delta, GSet):
	temphp = PlayerHealth
	tempCoins = PlayerCoins
	tempKeys = PlayerKeys
	
	match GSet:
		"SET":
			match name:
				"HP":
					PlayerHealth = PlayerHealth + delta
				"COINS":
					PlayerCoins = PlayerCoins + delta
				"KEYS":
					PlayerKeys = PlayerKeys + delta
				"STAMINA":
					PlayerStamina = PlayerStamina + delta
		"GET":
			match name:
				"HP":
					return PlayerHealth
				"COINS":
					return PlayerCoins
				"KEYS":
					return PlayerKeys
				"STAMINA":
					return PlayerStamina

	if temphp != PlayerHealth: 
		pass
		#print("Player Health: "+ str(PlayerHealth) + " Delta " + str(delta) + " - global")
	if tempCoins != PlayerCoins: 
		print("Player Coins: "+ str(PlayerCoins) + " Delta " + str(delta) + " - global")
	if tempKeys != PlayerKeys:
		print("Player Keys: "+ str(PlayerKeys) + " Delta " + str(delta) + " - global")


