extends Node2D
@export var shopLVL:int
var shop_ready:bool = false
var shop_num: int
func _ready():
	$Colision/Area2D.connect("body_entered",body_entered)
	$Colision/Area2D.connect("body_exited",body_exited)
	shop_num = $".".get_parent().add_in_list(shopLVL)
	create_shop_slots()
	load_shop_info()	
	
func _physics_process(_delta):
	if Input.is_action_just_released("special_use") and shop_ready:
		shop_enter()
		global.action_toggle = false
		shop_ready = false

func shop_enter():
	global.visible_scene("hud",false)
	global.visible_scene("inventory",false)
	global.visible_scene("shop",true)


func create_shop_slots():
	var node = $".".get_child(4)
	for i in len(itemlist.shop_storage[shopLVL]):
		var new_scene: Object = load("res://Scenes/shop/shop_item.tscn").instantiate()
		node.add_child(new_scene)
		
func load_shop_info():
	var node = $".".get_child(4)
	for i in node.get_child_count():
		slot(i,itemlist.shop_storage[shopLVL][i],false)

func slot(slotnum:int ,num:int,discription:bool): ##задать содержимое слота (изначально)
	var node = $".".get_child(4)
	if num == -1:
		num = 0
	node.get_child(slotnum).get_child(0).disabled = true
	node.get_child(slotnum).get_child(0).get_child(0).slot(num,false,discription)


func body_entered(body):
	if str(body.name) == "player":
		print("вход в территорию магазина - shop_interface")
		global.action_toggle = true
		global.attack_block = true
		shop_ready = true
		global.shop_lvl = shopLVL

func body_exited(body):
	if str(body.name) == "player":
		print("выход из территории магазина - shop_interface")
		global.action_toggle = false
		global.attack_block = false
		shop_ready = false
