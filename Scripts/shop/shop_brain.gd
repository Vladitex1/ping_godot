extends Control

@onready var cost_lable = $shop_plate/text/cost
@onready var sell_cost_lable = $shop_plate/text/sell_cost
@onready var name_lable = $shop_plate/text/name
@onready var count_lable = $shop_plate/text/count
@onready var keys_lable = $shop_plate/text/keys
@onready var coins_lable = $shop_plate/text/coins
@onready var buy_button = $shop_plate/buttons/buy_button
@onready var sell_button = $shop_plate/buttons/sell_button
@onready var eye_right = $eyes/eye_right
@onready var eye_left = $eyes/eye_left
@onready var intresting_slot = $shop_plate/IntrestingSlot
static var standart_label = ["name","count","cost","sell"]

var num123 = -1 ##debug
var count:int = 1

var cost:int
var sell_cost:int
var coststr:String
var name1: String

var selected_item: int = 0
var selected_item_ID: int = -1

	
func _ready():	
	global.attack_block = true
	intresting_slot.play("intresting_item_play")
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

	shop_info_storage(0)#randi_range(0,3))
	##shop inventory
	
func eyes():
	var mouse_pos = get_local_mouse_position().angle()
	eye_left.rotation = mouse_pos
	eye_right.rotation = mouse_pos
	
	
func _process(_delta):
	eyes()
	buttons_control()
	coins_lable.text = str(global.PlayerIndicators("coin", 0, "get"))
	keys_lable.text = str(global.PlayerIndicators("key", 0, "get"))
	
	if selected_item_ID == -2 or selected_item_ID == -1:
		name_lable.visible = false
		count_lable.visible = false
		cost_lable.visible = false
		sell_cost_lable.visible = false
	else:
		name_lable.visible = true
		count_lable.visible = true
		cost_lable.visible = true
		sell_cost_lable.visible = true
		
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
		global.hud_load()
		global.action_tougle = true
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
	if count <= 1:
		count = 1
	else:
		count = count - 1	

func plus_button():
	count = count + 1
	
func buttons_control():
	####sell
	if global.PlayerIndicators("key",0,"get") < count and selected_item_ID == 1:
		sell_button.disabled = true
	elif global.PlayerIndicators("hp",0,"get") < count*30 and selected_item_ID == 3:
		sell_button.disabled = true
	else:
		sell_button.disabled = false
	###buy
	if global.PlayerIndicators("coin",0,"get") < itemlist.itemlist[selected_item_ID][0]*count or global.PlayerIndicators("coin",0,"get") <= 0:
		buy_button.disabled = true
	elif global.PlayerIndicators("coin",0,"get") < itemlist.itemlist[selected_item_ID][0]*count and selected_item_ID == 3:
		buy_button.disabled = true
	elif global.PlayerIndicators("coin",0,"get") > 0:
		buy_button.disabled = false
		
func buy_button_func():###################дописать
	match selected_item_ID:
		1:
			global.PlayerIndicators("key",count,"set")
			global.PlayerIndicators("coin",itemlist.itemlist[selected_item_ID][0]*-1,"set")
		2:
			pass
		3:
			global.PlayerIndicators("hp",count*25,"set")
			global.PlayerIndicators("coin",itemlist.itemlist[selected_item_ID][0]*-1,"set")
		_:
			global.PlayerIndicators("coin",itemlist.itemlist[selected_item_ID][0]*-1,"set")
	
func sell_button_func():###################дописать
	match selected_item_ID:
		1:
			global.PlayerIndicators("key",count*-1,"set")
			global.PlayerIndicators("coin",itemlist.itemlist[selected_item_ID][3]*count,"set") 
		2:
			pass
		3:
			global.PlayerIndicators("hp",count*-30,"set")
			global.PlayerIndicators("coin",itemlist.itemlist[selected_item_ID][3]*count,"set")
			
		_:
			global.PlayerIndicators("coin",itemlist.itemlist[selected_item_ID][3]*count,"set")
			
func exit_button():
	print("shop_exit - shop_brain")
	global.del_scene("shop")
	#global.del_scene("inventory")
	global.hud_load()
	global.action_tougle = true
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
