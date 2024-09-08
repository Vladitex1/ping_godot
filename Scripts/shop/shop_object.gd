extends Node2D

var shop_ready = false

func _ready():
	$Colision/Area2D.connect("body_entered",body_entered)
	$Colision/Area2D.connect("body_exited",body_exited)
	
func _physics_process(_delta):
	if Input.is_action_just_released("special_use") and shop_ready:
		shop_enter()
		global.action_toggle = false
		shop_ready = false

func shop_enter():
	global.visible_scene("hud",false)
	global.visible_scene("inventory",false)
	global.visible_scene("shop",true)

func body_entered(body):
	if str(body.name) == "player":
		print("вход в территорию магазина - shop_interface")
		global.action_toggle = true
		global.attack_block = true
		shop_ready = true

func body_exited(body):
	if str(body.name) == "player":
		print("выход из территории магазина - shop_interface")
		global.action_toggle = false
		global.attack_block = false
		shop_ready = false

