extends Node

static var scene1 = preload("res://Scenes/shop.tscn").instantiate()
static var scene2 = preload("res://Scenes/hud.tscn").instantiate()
static var scene3 = preload("res://Scenes/inventory.tscn").instantiate()

var shop_tougle = false
var action_tougle = false
var loading_tougle = false
var heat_tougle = false
static var ret: bool = false
var door_list = {}
var player_position: Vector2

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
	return ret

func hud_load():
	#return 0
	global.add_scene("hud")
	global.add_scene("inventory")

func set_player_pos(vector):
	player_position = vector
func get_player_pos():
	return player_position
