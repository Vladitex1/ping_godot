extends Node


var shop_tougle:bool = false
var action_tougle:bool = false
var loading_tougle:bool = false
var heat_tougle:bool = false
var attack_tougle:bool = false
var buttons_lock: bool = false

static var drag_tougle:bool = false
static var brightness:float = 1
static var ret: bool = false
static var attack_block:bool = false

static var PlayerHealth: int
static var MaxHealth: int
static var PlayerStamina: int
static var MaxStamina: int

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
	
func change_scene(namestr):
	get_tree().change_scene_to_file("res://Scenes/"+namestr+".tscn")
	
func add_scene(namestr):
	get_tree().root.add_child(load("res://Scenes/"+namestr+".tscn").instantiate())
		
func del_scene(namestr):
	var scene = "res://Scenes/"+namestr+".tscn"
	for i in get_tree().root.get_child_count():
		if get_tree().root.get_child(i).name == namestr:
			print(get_tree().root.get_child(i).name)
			scene = get_tree().root.get_child(i)
			scene.queue_free()
	#print(get_tree().root.get_child_count())
	
	
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
	
func incomingPlayerDamage(namestr, delta, GSET):
	match GSET:
		"set":
			match namestr:
				"damage":
					Damage = delta
				"damage_throw":
					Damage_Throw = delta
		"get":
			match namestr:
				"damage":
					return Damage
				"damage_throw":
					return Damage_Throw

func player_attack(namestr, delta, GSET):

	match GSET:
		"set":
			match namestr:
				"damage":
					Damage = delta
				"damage_throw":
					Damage_Throw = delta
		"get":
			match namestr:
				"damage":
					return Damage
				"damage_throw":
					return Damage_Throw


func PlayerIndicators(namestr, delta, GSet):
	temphp = PlayerHealth
	tempCoins = PlayerCoins
	tempKeys = PlayerKeys
	
	match GSet:
		"set":
			match namestr:
				"hp":
					PlayerHealth = PlayerHealth + delta
					if PlayerHealth > MaxHealth:
						PlayerHealth = MaxHealth
				"coin":
					PlayerCoins = PlayerCoins + delta
				"key":
					PlayerKeys = PlayerKeys + delta
				"stamina":
					PlayerStamina = PlayerStamina + delta
		"get":
			match namestr:
				"hp":
					return PlayerHealth
				"coin":
					return PlayerCoins
				"key":
					return PlayerKeys
				"stamina":
					return PlayerStamina

	if temphp != PlayerHealth: 
		pass
		#print("Player Health: "+ str(PlayerHealth) + " Delta " + str(delta) + " - global")
	if tempCoins != PlayerCoins: 
		print("Player Coins: "+ str(PlayerCoins) + " Delta " + str(delta) + " - global")
	if tempKeys != PlayerKeys:
		print("Player Keys: "+ str(PlayerKeys) + " Delta " + str(delta) + " - global")


