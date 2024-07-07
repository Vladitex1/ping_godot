extends Control

@onready var cost_lable = $shop_plate/text/cost
@onready var sell_cost_lable = $shop_plate/text/sell_cost
@onready var name_lable = $shop_plate/text/name
@onready var count_lable = $shop_plate/text/count
@onready var keys_lable = $shop_plate/text/keys
@onready var coins_lable = $shop_plate/text/coins
@onready var buy_button = $shop_plate/buttons/buy_button
@onready var sell_button = $shop_plate/buttons/sell_button
@onready var eye_right = $shop_plate/eyes/eye_right
@onready var eye_left = $shop_plate/eyes/eye_left

var standart_label = ["name","count","cost","sell"]

var num123 = -1

var count:int = 1
var countstr:String

var cost:int
var sell_cost:int
var coststr:String
var name1: String

var selected_item: int = 0
var selected_item_ID: int = -1

	
func _ready():	
	countstr = str(count)
	global.attack_block = true
	$shop_plate/buttons/minus_button.connect("button_up",minus_button)
	$shop_plate/buttons/buy_button.connect("button_up",buy_button_func)
	$shop_plate/buttons/plus_button.connect("button_up",plus_button)
	$shop_plate/buttons/sell_button.connect("button_up",sell_button_func)
	$shop_plate/buttons/exit_button.connect("button_up",exit_button)

	##buttons
	$shop_plate/items/GridContainer/Slot1/Button.connect("button_down",slot1)
	$shop_plate/items/GridContainer/Slot2/Button.connect("button_down",slot2)
	$shop_plate/items/GridContainer/Slot3/Button.connect("button_down",slot3)
	$shop_plate/items/GridContainer/Slot4/Button.connect("button_down",slot4)
	$shop_plate/items/GridContainer/Slot5/Button.connect("button_down",slot5)
	$shop_plate/items/GridContainer/Slot6/Button.connect("button_down",slot6)
	$shop_plate/items/GridContainer/Slot7/Button.connect("button_down",slot7)
	$shop_plate/items/GridContainer/Slot8/Button.connect("button_down",slot8)

	shop_info_storage(randi_range(0,3))
	##shop inventory
func eyes():
	var mouse_pos = get_local_mouse_position().angle()
	var mouse_pos2 = get_local_mouse_position()
	eye_left.rotation = mouse_pos
	eye_right.rotation = mouse_pos
	print("левое: ",eye_left.get_screen_position())
	print("правое: ",eye_right.get_screen_position())
	print("мышь: ",mouse_pos2)
func _process(delta):
	
	eyes()
	
	
	
	print(selected_item_ID)
	coins_lable.text = str(global.PlayerIndicators("COINS", 0, "GET"))
	keys_lable.text = str(global.PlayerIndicators("KEYS", 0, "GET"))
	
	if selected_item_ID == -2 or selected_item_ID == -1:
		name_lable.text = standart_label[0]
		count_lable.text = standart_label[1]
		cost_lable.text = standart_label[2]
		sell_cost_lable.text = standart_label[3]
	else:
		cost = itemlist.itemlist[selected_item_ID][0] * count
		sell_cost = itemlist.itemlist[selected_item_ID][3] * count
		cost_lable.text = str(cost)
		sell_cost_lable.text = str(sell_cost)
		name_lable.text = itemlist.itemlist[selected_item_ID][2]
		count_lable.text = str(count)
	
	if Input.is_action_just_released("debug1"):
		num123 = num123 + 1
		if num123 > 3:
			num123 = 0
			shop_info_storage(num123)
		else:
			shop_info_storage(num123)
			
	elif Input.is_action_just_pressed("special_back"):
		print("shop_exit - shop_brain")
		global.del_scene("shop")
		#global.del_scene("inventory")
		global.hud_load()
		global.set_tougle(3,true)
		global.attack_block = false

###################Содержимое магазина###################
	
func shop_info_storage(num1):
	var slotnumber = 1
	while slotnumber <= 8:
		slot(slotnumber,itemlist.shop_storage[num1][slotnumber-1])
		slotnumber = slotnumber + 1
		
func random_items_in_slots():
	var slotnumber = 0
	while slotnumber != 8:
		slotnumber = slotnumber + 1
		slot(slotnumber,randi_range(0,4))
		
#########################Кнопки##########################
func minus_button():
	countstr = str(count)
	if count <= 0:
		count = 0
	else:
		count = count - 1	
func plus_button():
	count = count + 1
	countstr = str(count)
	
func buy_button_func():
	if global.PlayerIndicators("COINS",0,"GET") < itemlist.itemlist[selected_item_ID][0] or global.PlayerIndicators("COINS",0,"GET") <= 0:
		buy_button.disabled = true
	elif global.PlayerIndicators("COINS",0,"GET") > 0:
		buy_button.disabled = false
		match selected_item_ID:
			1:
				global.PlayerIndicators("KEYS",count,"SET")
				global.PlayerIndicators("COINS",itemlist.itemlist[selected_item_ID][0]*-1,"SET")
			2:
				pass
			_:
				global.PlayerIndicators("COINS",itemlist.itemlist[selected_item_ID][0]*-1,"SET")

	
func sell_button_func():###################дописать
	if global.PlayerIndicators("KEYS",0,"GET") < count:
		buy_button.disabled = true
	else:
		buy_button.disabled = false
		match selected_item_ID:
			1:
				global.PlayerIndicators("KEYS",count*-1,"SET")
				global.PlayerIndicators("COINS",itemlist.itemlist[selected_item_ID][3],"SET") 
			2:
				pass
			_:
				global.PlayerIndicators("COINS",itemlist.itemlist[selected_item_ID][3],"SET")
			
func exit_button():
	print("shop_exit - shop_brain")
	global.del_scene("shop")
	#global.del_scene("inventory")
	global.hud_load()
	global.set_tougle(3,true)
	global.attack_block = false

################## Задать содержимое слота


func slot(slotnum,num):
	match slotnum:
		1:
			$shop_plate/items/GridContainer/Slot1/Button/shop_item_1.slot(num)
		2:
			$shop_plate/items/GridContainer/Slot2/Button/shop_item_2.slot(num)
		3:
			$shop_plate/items/GridContainer/Slot3/Button/shop_item_3.slot(num)
		4:
			$shop_plate/items/GridContainer/Slot4/Button/shop_item_4.slot(num)
		5:
			$shop_plate/items/GridContainer/Slot5/Button/shop_item_5.slot(num)
		6:
			$shop_plate/items/GridContainer/Slot6/Button/shop_item_6.slot(num)
		7:
			$shop_plate/items/GridContainer/Slot7/Button/shop_item_7.slot(num)
		8:
			$shop_plate/items/GridContainer/Slot8/Button/shop_item_8.slot(num)
		_:
			pass
	
	
func slot1():
	selected_item_ID = $shop_plate/items/GridContainer/Slot1/Button/shop_item_1.get_slot_info()
	count = 1
func slot2():
	selected_item_ID = $shop_plate/items/GridContainer/Slot2/Button/shop_item_2.get_slot_info()
	count = 1
func slot3():
	selected_item_ID = $shop_plate/items/GridContainer/Slot3/Button/shop_item_3.get_slot_info()
	count = 1
func slot4():
	selected_item_ID = $shop_plate/items/GridContainer/Slot4/Button/shop_item_4.get_slot_info()
	count = 1
func slot5():
	selected_item_ID = $shop_plate/items/GridContainer/Slot5/Button/shop_item_5.get_slot_info()
	count = 1
func slot6():
	selected_item_ID = $shop_plate/items/GridContainer/Slot6/Button/shop_item_6.get_slot_info()
	count = 1
func slot7():
	selected_item_ID = $shop_plate/items/GridContainer/Slot7/Button/shop_item_7.get_slot_info()
	count = 1
func slot8():
	selected_item_ID = $shop_plate/items/GridContainer/Slot8/Button/shop_item_8.get_slot_info()
	count = 1
