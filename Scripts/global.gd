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
static var drag_tougle:bool = false
static var brightness:float = 1
static var ret: bool = false

var PlayerHP: int = 100
static var PlayerKeys: int = 1
static var PlayerCoins: int = 5

var door_list = {}
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
			
func set_tougle(num,status):
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
			
func get_tougle(num):
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
	return ret

func hud_load():
	#return 0
	global.add_scene("hud")
	global.add_scene("inventory")
	

func set_player_pos(vector):
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
	
	
func PlayerIndicators(name, delta, GSet):
	match GSet:
		"set":
			match name:
				"HP":
					PlayerHP = PlayerHP + delta
					print("Player Health: "+ str(PlayerHP) + " uuDelta " + str(delta) + " - global")
				"Coins":
					PlayerCoins = PlayerCoins + delta
					print("Player Coins: "+ str(PlayerCoins) + " Delta " + str(delta) + " - global")
				"Keys":
					PlayerKeys = PlayerKeys + delta
					print("Player Keys: "+ str(PlayerKeys) + " Delta " + str(delta) + " - global")
		"get":
			match name:
				"HP":
					return PlayerHP
				"Coins":
					return PlayerCoins
				"Keys":
					return PlayerKeys

	
