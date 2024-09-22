extends Control

@export var shopLVL = 1
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
	intresting_slot.play("intresting_item_play")
	$shop_plate/buttons/minus_button.connect("button_up",minus_button)
	$shop_plate/buttons/buy_button.connect("button_up",buy_button_func)
	$shop_plate/buttons/plus_button.connect("button_up",plus_button)
	$shop_plate/buttons/sell_button.connect("button_up",sell_button_func)
	$shop_plate/buttons/exit_button.connect("button_up",exit_button)

	##buttons
	
	for slotnum in get_node("shop_plate/items/GridContainer").get_child_count():
		#print(slotnum+1)
		slotnum = slotnum + 1
		var node_path: String = "shop_plate/items/GridContainer/Slot"+str(slotnum)+"/Button"
		var button = get_node(node_path)
		button.connect("button_down",Callable(self, "slotnum").bind(slotnum))

	shop_info_storage(0)#randi_range(0,3))
	##shop inventory
	node_reset(config.BASE_RES_NUM)
	
func node_reset(res):
	var scaled = config.resolution_list[res][2]
	var positioned = Vector2(config.resolution_list[res][3],config.resolution_list[res][4])
	scale = Vector2(scaled,scaled)
	position = positioned	

	
	
	
func eyes():
	var mouse_pos = get_local_mouse_position().angle()
	eye_left.rotation = mouse_pos
	eye_right.rotation = mouse_pos
	
	
func _process(_delta):
	eyes()
	buttons_control()

	var state: bool
	if selected_item_ID == -2 or selected_item_ID == -1:
		state = false
	else:
		state = true
		
	name_lable.visible = state
	count_lable.visible = state
	cost_lable.visible = state
	sell_cost_lable.visible = state
	
	coins_lable.text = str(global.player_indicators("coin", 0, "get"))
	keys_lable.text = str(global.player_indicators("key", 0, "get"))
	cost = itemlist.itemlist[selected_item_ID][0] * count
	sell_cost = itemlist.itemlist[selected_item_ID][3] * count
	cost_lable.text = str(cost)
	sell_cost_lable.text = str(sell_cost)
	name_lable.text = itemlist.itemlist[selected_item_ID][2]
	count_lable.text = str(count)
	if Input.is_action_just_released("special_back"):
		exit_button()
		
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
	if count <= 1:
		count = 1
	else:
		count = count - 1	

func plus_button():
	count = count + 1
	
func buttons_control():
	####sell
	if global.player_indicators("key",0,"get") < count and selected_item_ID == 1:
		sell_button.disabled = true
	elif global.player_indicators("hp",0,"get") < count*30 and selected_item_ID == 3:
		sell_button.disabled = true
	else:
		sell_button.disabled = false
	###buy
	if global.player_indicators("coin",0,"get") < itemlist.itemlist[selected_item_ID][0]*count or global.player_indicators("coin",0,"get") <= 0:
		buy_button.disabled = true
	elif global.player_indicators("coin",0,"get") < itemlist.itemlist[selected_item_ID][0]*count and selected_item_ID == 3:
		buy_button.disabled = true
	elif global.player_indicators("coin",0,"get") > 0:
		buy_button.disabled = false
		
func buy_button_func():###################дописать
	match selected_item_ID:
		1:
			global.player_indicators("key",count,"set")
			global.player_indicators("coin",itemlist.itemlist[selected_item_ID][0]*-1,"set")
		2:
			pass
		3:
			global.player_indicators("hp",count*25,"set")
			global.player_indicators("coin",itemlist.itemlist[selected_item_ID][0]*-1,"set")
		_:
			global.player_indicators("coin",itemlist.itemlist[selected_item_ID][0]*-1,"set")
	
func sell_button_func():###################дописать
	match selected_item_ID:
		1:
			global.player_indicators("key",count*-1,"set")
			global.player_indicators("coin",itemlist.itemlist[selected_item_ID][3]*count,"set") 
		2:
			pass
		3:
			global.player_indicators("hp",count*-30,"set")
			global.player_indicators("coin",itemlist.itemlist[selected_item_ID][3]*count,"set")
			
		_:
			global.player_indicators("coin",itemlist.itemlist[selected_item_ID][3]*count,"set")
			
func exit_button():
	global.visible_scene("hud",true)
	global.visible_scene("inventory",true)
	global.visible_scene("shop",false)
	
	#global.add_scene("inventory")
	

################## Задать содержимое слота

func slot(slotnum,num):
	var slotnum2 = str(slotnum)
	var node_path = "shop_plate/items/GridContainer/Slot" + slotnum2 + "/Button/shop_item_" + slotnum2
	get_node(node_path).slot(num)
	
func slotnum(slotnum):
	var slotnum2 = str(slotnum)
	var node_path = "shop_plate/items/GridContainer/Slot" + slotnum2 + "/Button/shop_item_" + slotnum2
	selected_item_ID = get_node(node_path).get_slot_info()
	count = 1
