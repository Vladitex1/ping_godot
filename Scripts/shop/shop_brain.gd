extends Control

@onready var cost_lable = $shop_plate/text/cost
@onready var name_lable = $shop_plate/text/name
@onready var count_lable = $shop_plate/text/count

var standart_label = ["name","count","cost"]

var num123 = -1

var count:int = 1
var countstr:String

var cost:int = 0
var coststr:String
var name1: String

var selected_item: int = 0
var selected_item_ID: int = -2

	
func _ready():	
	countstr = str(count)
	$shop_plate/buttons/minus_button.connect("button_up",minus_button)
	$shop_plate/buttons/buy_button.connect("button_up",buy_button)
	$shop_plate/buttons/plus_button.connect("button_up",plus_button)
	$shop_plate/buttons/sell_button.connect("button_up",sell_button)
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

func _process(delta):
	if selected_item_ID == -2 or selected_item_ID == -1:
		cost_lable.text = standart_label[2]
		name_lable.text = standart_label[0]
		count_lable.text = standart_label[1]
	else:
		cost = itemlist.itemlist[selected_item_ID][0] * count
		cost_lable.text = str(cost)
		
		name_lable.text = itemlist.itemlist[selected_item_ID][2]
		count_lable.text = str(count)
	
	if Input.is_action_just_released("debug1"):
		num123 = num123 + 1
		if num123 > 3:
			num123 = 0
			shop_info_storage(num123)
		else:
			shop_info_storage(num123)


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
	
func buy_button():
	pass
func sell_button():
	pass
func exit_button():
	print("shop_exit - shop_brain")
	global.del_scene("shop")
	#global.del_scene("inventory")
	global.hud_load()
	global.set_tougle(3,true)

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
