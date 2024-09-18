extends Node


var shop_toggle:bool = false
var action_toggle:bool = false
var pickup_toggle: bool = false

var heat_toggle:bool = false
var buttons_lock: bool = false
var hold_in_hands: bool = false


static var drag_toggle:bool = false
static var brightness:float = 0.4
static var ret: bool = false
var attack_block:bool = false

static var player_health: int
static var max_health: int
static var player_stamina: int
static var max_stamina: int

static var player_keys: int
static var player_coins: int

static var attack_strange: int
static var attack_throw: int
static var damage: int
static var damage_throw: int

var temp_hp:int = player_health
var temp_coins:int = player_coins
var temp_keys:int = player_keys
var temp_stamina:int = player_stamina

static var player_position: Vector2
static var camera_position: Vector2
static var camera_zoom: Vector2
static var stamina_limit: int
static var dragging:bool = false



func change_scene(namestr):
	get_tree().change_scene_to_file("res://Scenes/"+namestr+".tscn")
	
func add_scene(namestr):#add_child(
	var new_scene: Object = load("res://Scenes/"+namestr+".tscn").instantiate()
	get_tree().root.add_child(new_scene)

func visible_scene(namestr: String, status: bool):
	for i in get_tree().root.get_child_count():
		if get_tree().root.get_child(i).name == namestr:
			get_tree().root.get_child(i).visible = status

func viev_scene_list():
	for i in get_tree().root.get_child_count():
		print(get_tree().root.get_child(i).name)
		
	print("~~~~~~~~~~~~~~~~~~~~~~~~~")
	
func reload_scene(namestr):	
	del_scene(namestr)
	add_scene(namestr)
	
func del_scene(namestr):
	var scene = namestr
	for i in get_tree().root.get_child_count():
		if get_tree().root.get_child(i).name == namestr:
			print(get_tree().root.get_child(i).name)
			scene = get_tree().root.get_child(i)
			scene.queue_free()
		

func set_player_pos(vector: Vector2):
	player_position = vector

func get_player_pos():
	return player_position

func player_attack(namestr, delta, GSET):
	match GSET:
		"set":
			match namestr:
				"damage":
					attack_strange = delta
				"damage_throw":
					attack_throw = delta
		"get":
			match namestr:
				"damage":
					return attack_strange
				"damage_throw":
					return attack_throw

func player_damage(namestr, delta, GSET):

	match GSET:
		"set":
			match namestr:
				"damage":
					damage = delta
				"damage_throw":
					damage_throw = delta
		"get":
			match namestr:
				"damage":
					return damage
				"damage_throw":
					return damage_throw

func player_indicators(namestr, delta, GSet):
	temp_hp = player_health
	temp_coins = player_coins
	temp_keys = player_keys
	
	match GSet:
		"set":
			match namestr:
				"hp":
					player_health = player_health + delta
					if player_health > max_health:
						player_health = max_health
					elif player_health <= 0:
						player_health = 0
				"coin":
					player_coins = player_coins + delta
				"key":
					player_keys = player_keys + delta
				"stamina":
					player_stamina = player_stamina + delta
					if player_stamina > max_stamina:
						player_stamina = max_stamina
					elif player_stamina <= 0:
						player_stamina = 0
		"get":
			match namestr:
				"hp":
					return player_health
				"coin":
					return player_coins
				"key":
					return player_keys
				"stamina":
					return player_stamina

	if temp_hp != player_health: 
		pass
		#print("Player Health: "+ str(player_health) + " Delta " + str(delta) + " - global")
	if temp_coins != player_coins: 
		print("Player Coins: "+ str(player_coins) + " Delta " + str(delta) + " - global")
	if temp_keys != player_keys:
		print("Player Keys: "+ str(player_keys) + " Delta " + str(delta) + " - global")


