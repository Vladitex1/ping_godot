extends Control

@onready var cost_lable = $shop_plate/text/cost
@onready var sell_cost_lable = $shop_plate/text/sell_cost
@onready var name_lable = $shop_plate/text/name
@onready var count_lable = $shop_plate/text/count
@onready var keys_lable = $shop_plate/text/keys
@onready var coins_lable = $shop_plate/text/coins
@onready var buy_button = $shop_plate/buttons/buy_button
@onready var sell_button = $shop_plate/buttons/sell_button
@onready var intresting_slot = $shop_plate/IntrestingSlot
var inventory: bool = false
static var standart_label = ["name","count","cost","sell"]
var number_of_element: String
var shop_num: int
var shop_lvl:int
var ift: bool = false
var max_symbols: int = 2
var count:int = 1
var cost:int
var sell_cost:int
var coststr:String
var name1: String

var selected_item: int = 0
var selected_item_ID: int = -1

enum numpad {
	insert,
	extract,
	clear,
	enter
	}
	
func _ready():	
	print("shop_lvl - ",shop_lvl)
	intresting_slot.play("intresting_item_play")
	$shop_plate/buttons/buy_button.connect("button_up",buy_button_func)
	$shop_plate/buttons/sell_button.connect("button_up",sell_button_func)
	###стартовая подготовка слотов
	create_shop_slots() ##создание слотов
	 
	num_buttons() ###заполнение слотов инветаря
	stall_slots() ###создание слотов содержимого магазина
	
	#node_reset(config.BASE_RES_NUM) ###меняем разрешение экрана
	
func _process(_delta):
	if Input.is_action_just_released("special_back"):
		exit_button()
	if $"..".visible == true and !ift:
		ift = true
		shop_lvl = global.shop_lvl
		coins_lable.text = str(global.player_indicators("coin", 0, "get"))
		load_shop_info() ###заполнение слотов содержимого магазина
		connect_shop_slots() ##присоединение сигналов слотов
	#name_lable.visible = state
	#count_lable.visible = state
	#cost_lable.visible = state
	#sell_cost_lable.visible = state
	
	#coins_lable.text = str(global.player_indicators("coin", 0, "get"))
	#keys_lable.text = str(global.player_indicators("key", 0, "get"))
	#cost = itemlist.itemlist[selected_item_ID]["BUYCOST"] * count
	#sell_cost = itemlist.itemlist[selected_item_ID]["SELLCOST"] * count
	#cost_lable.text = str(cost)
	#sell_cost_lable.text = str(sell_cost)
	#name_lable.text = itemlist.itemlist[selected_item_ID]["NAME"]
	#count_lable.text = str(count)

		

###################Содержимое магазина###################

func create_shop_slots():
	var node = $".".get_child(0).get_child(3).get_child(0)
	for i in len(itemlist.shop_storage[shop_lvl]):
		var new_scene: Object = load("res://Scenes/shop/shop_item.tscn").instantiate()
		node.add_child(new_scene)

func connect_shop_slots():
	var node = $".".get_child(0).get_child(3).get_child(0)
	var node2 = $".".get_child(0).get_child(3).get_child(1)
	for i in node.get_child_count():
		node.get_child(i).get_child(0).connect("button_down",Callable(self, "slot_feedback").bind(i))
		#node.get_child(i).get_child(0).connect("mouse_entered",Callable(self, "show_discr").bind(i))
		#node.get_child(i).get_child(0).connect("mouse_exited",Callable(self, "hide_discr").bind(i))
	for i in node2.get_child_count():
		node2.get_child(i).get_child(0).connect("mouse_entered",Callable(self, "show_discr").bind(i))
		node2.get_child(i).get_child(0).connect("mouse_exited",Callable(self, "hide_discr").bind(i))
		#button.connect("focus_exited",xuy)

func show_discr(num:int):
	print("ХУй")
	var button_path:Object = $shop_plate/items
	button_path = button_path.get_child(1)
	var discription = button_path.get_child(num).get_child(1)
	var need = button_path.get_child(num).get_child(0).get_child(0).get_slot_info()
	if need == 0 or need == -1:
		pass
	else:
		if button_path.get_child(num).get_child(0).get_child(0).get_discr_info():
			discription.visible = true
	
func hide_discr(num:int):
	var button_path:Object = $shop_plate/items
	button_path = button_path.get_child(1)
	var discription = button_path.get_child(num).get_child(1)
	discription.visible = false
		
		
		
func load_shop_info(): 
	print(shop_lvl)
	var node = $".".get_child(0).get_child(3).get_child(1)
	for i in range(node.get_child_count()):
		node.get_child(i).get_child(0).get_child(0).slot(itemlist.shop_storage[shop_lvl][i],false,true)
		node.get_child(i).get_child(0).flat = true
		node.get_child(i).get_child(0).disabled = true
		
func num_buttons():
	var node = $".".get_child(0).get_child(3).get_child(0)
	var num: int = 1
	for i in range($".".get_child(0).get_child(3).get_child(0).get_child_count()):
		if i < 13:
			match i:
				3:
					node.get_child(i).get_child(0).get_child(0).slot(-12,false,false)
				7:
					node.get_child(i).get_child(0).get_child(0).slot(-13,false,false)
				11:
					node.get_child(i).get_child(0).get_child(0).slot(-11,false,false)
				12:
					node.get_child(i).get_child(0).get_child(0).slot(0,true,false)
				_:
					node.get_child(i).get_child(0).get_child(0).slot(num,true,false)
					num+=1
		else:
			node.get_child(i).get_child(0).get_child(0).slot(0,false,false)
			node.get_child(i).get_child(0).disabled = true

func stall_slots():	
	var node = $".".get_child(0).get_child(3).get_child(1)
	for i in len(itemlist.shop_storage[shop_lvl]):
		var new_scene: Object = load("res://Scenes/shop/shop_item.tscn").instantiate()
		node.add_child(new_scene)
	
	
	
	
func slot(slotnum,num,numbutton): ##задать содержимое слота (изначально)
	var node = $".".get_child(0).get_child(3).get_child(0)
	node.get_child(slotnum).get_child(0).get_child(0).slot(num,numbutton,false)
	
#################Окно магазина##########################

func node_reset(res):
	var scaled = config.resolution_list[res][5]
	var positioned = Vector2(config.resolution_list[res][3],config.resolution_list[res][4])
	scale = Vector2(scaled,scaled)
	position = positioned	

	
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
	if global.player_indicators("key",0,"get") < count and selected_item_ID == 3:
		sell_button.disabled = true
	elif global.player_indicators("hp",0,"get") < count*30 and selected_item_ID == 1:
		sell_button.disabled = true
	else:
		sell_button.disabled = false
	###buy
	if global.player_indicators("coin",0,"get") < itemlist.itemlist[selected_item_ID]["BUYCOST"]*count or global.player_indicators("coin",0,"get") <= 0:
		buy_button.disabled = true
	elif global.player_indicators("coin",0,"get") < itemlist.itemlist[selected_item_ID]["BUYCOST"]*count and selected_item_ID == 3:
		buy_button.disabled = true
	elif global.player_indicators("coin",0,"get") > 0:
		buy_button.disabled = false
		
func buy_button_func():###################дописать!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	match selected_item_ID:
		3:
			global.player_indicators("key",count,"set")
			global.player_indicators("coin",itemlist.itemlist[selected_item_ID]["BUYCOST"]*-1,"set")
		2:
			pass
		1:
			global.player_indicators("hp",count*25,"set")
			global.player_indicators("coin",itemlist.itemlist[selected_item_ID]["BUYCOST"]*-1,"set")
		_:
			global.player_indicators("coin",itemlist.itemlist[selected_item_ID]["BUYCOST"]*-1,"set")
	
func sell_button_func():###################дописать
	match selected_item_ID:
		3:
			global.player_indicators("key",count*-1,"set")
			global.player_indicators("coin",itemlist.itemlist[selected_item_ID]["SELLCOST"]*count,"set") 
		2:
			pass
		1:
			global.player_indicators("hp",count*-30,"set")
			global.player_indicators("coin",itemlist.itemlist[selected_item_ID]["SELLCOST"]*count,"set")
			
		_:
			global.player_indicators("coin",itemlist.itemlist[selected_item_ID]["SELLCOST"]*count,"set")
			
func exit_button():
	global.visible_scene("hud",true)
	global.visible_scene("inventory",true)
	global.visible_scene("shop",false)
	#global.add_scene("inventory")
	ift = false
	
##################Технические##########################
	
func slot_feedback(slotnum): ##получение информации от слота
	var node: Object = $shop_plate/items
	node = node.get_child(0)
	var feedback: int = node.get_child(slotnum).get_child(0).get_child(0).get_slot_info()
	match inventory: 
		false:
			match feedback:
				-11: ###КНОПКА ентер
					screen_communicate(int(number_of_element),numpad.enter)
				-13: ###КНОПКА Стереть
					screen_communicate(0,numpad.extract)
				-12: ##КНОПКА удалить
					screen_communicate(0,numpad.clear)
				_: ###остльные кнопки добавить
					screen_communicate(feedback,numpad.insert)
		true:
			pass


func screen_communicate(num: int,action: int):
	var node: Object = $shop_plate/items/GridContainer
	match action:
		numpad.clear:
			number_of_element = ""
		numpad.insert:
			if len(number_of_element) <= max_symbols:
				number_of_element += str(num)
		numpad.extract: 
			if len(number_of_element) > 0:
				number_of_element = number_of_element.erase(len(number_of_element)-1,1)
		numpad.enter:
			if len(number_of_element) == max_symbols+1:
				change_item(int(number_of_element))
			number_of_element = ""
			
	var f: int = 13
	for i in range(max_symbols+1):
		node.get_child(f).get_child(0).get_child(0).slot(-256,true,false)
		f+=1
	f = 13
	for i in range(len(number_of_element)):
		node.get_child(f).get_child(0).get_child(0).slot(int(number_of_element[i]),true,false)
		f+=1

	print(number_of_element)


func change_item(item_id:int):
	print(item_id)
	var node: Object = $shop_plate
	var itemid_exeptions = [-256,-13,-12,-11,-1,0]
	if item_id not in itemid_exeptions:
		if item_id in itemlist.itemlist:
			var id = itemlist.shop_storage[shop_lvl][item_id-1]
			node.get_child(4).get_child(0).text = itemlist.itemlist[id]["NAME"]
			node.get_child(4).get_child(1).text = str(item_id)
			node.get_child(4).get_child(2).text = str("cost: ")+str(itemlist.itemlist[id]["BUYCOST"])
			node.get_child(6).texture = itemlist.itemlist[id]["TEXTURE"]
	

	
	
	
	
	
