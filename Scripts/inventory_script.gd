extends Control

@onready var show_animation = $inventory_pos_animation

var selected_slot_start: int = -1
var selected_slot_id_start: int = -1
var selected_slot_start_count: int = -1
var selected_slot_end: int = -1
var selected_slot_id_end: int = -1
var selected_slot_end_count: int = -1
var open = false
var mousetoggle: bool = true
var button_num: int

##для работы меню взаимодействия
var last_button: int = 0
var menu_toggle: bool = false

func _ready():
	create_slots()
	connect_slots()
	inventory_load() ###загрузка
	#inventory_reload(8) ###подгруз содержимого инвентаря
	#slot(3,2)
	#random_items_in_slots()
	#inventory_save() ###сохранение
	
	
func _process(_delta):
	if open and Input.is_action_just_released("special_back"):
		open = false
		global.attack_block = false
		show_animation.play_backwards("inventory_show_animation")
		menu_toggle = false
	if Input.is_action_just_released("special_tab"):
		#print(itemlist.inventory)
		inventory_load()
		inventory_toggle()
		#print(itemlist.inventory)
		#global.inventory = inventory
		print("inventory open - inventory_script")
	if Input.is_action_just_released("debugU"):
		inventory_reload(2)	
	if Input.is_action_just_released("debugI"):
		use_menu_break()
	#debug()

func debug():
	#print("menu_toggle ",menu_toggle)
	#print("itemlist.itemlist[selected_item_ID][1] ",itemlist.itemlist[3]["SELLCOST"])
	print("")
func create_slots(): ###Создание экземпляров кнопок
	var slot_directory = get_node("GridContainer")
	var slot_num = 0
	while slot_num < 16:
		var new_slot = load("res://Scenes/inventory/inventory_slot.tscn").instantiate()
		slot_directory.add_child(new_slot)
		slot_num += 1
		
func connect_slots():	###Подключение кнопок	
	#print("к: ",get_node("GridContainer").get_child_count())	
	for num in get_node("GridContainer").get_child_count():
		var button_path = get_node("GridContainer")
		var button = button_path.get_child(num).get_child(0)
		button.connect("button_up",Callable(self, "slotnum").bind(num))
		button.connect("mouse_entered",Callable(self, "show_discr").bind(num))
		button.connect("mouse_exited",Callable(self, "hide_discr").bind(num))


func show_discr(num:int):
	var button_path = get_node("GridContainer")
	var discription = button_path.get_child(num).get_child(1)
	var need = button_path.get_child(num).get_child(0).get_child(1).get_slot_info(1)
	if need == 0 or need == -1:
		pass
	else:
		discription.visible = true
	
func hide_discr(num:int):
	var button_path = get_node("GridContainer")
	var discription = button_path.get_child(num).get_child(1)
	discription.visible = false
	
func use_menu(num:int,special:bool):
	var button_path = get_node("GridContainer")
	var use_menu = button_path.get_child(num).get_child(2)
	var need = button_path.get_child(num).get_child(0).get_child(1).get_slot_info(1)
	if need == 0 or need == -1:
		pass
	else:
		if special == false: ##стандарт
			match menu_toggle:
				true:
					menu_toggle = false
				false:
					menu_toggle = true
			use_menu.visible = menu_toggle	
		else:
			menu_toggle = false
			use_menu.visible = false
			
	
func use_menu_break():
	var button_path = get_node("GridContainer")
	for slot_number in 16:
		var item_path = button_path.get_child(slot_number).get_child(0).get_child(1)
		use_menu(slot_number,true)

func inventory_save(): ###Сохранение инвентаря в itemlist
	var button_path = get_node("GridContainer")
	for slot_number in 16:
		var item_path = button_path.get_child(slot_number).get_child(0).get_child(1)
		itemlist.inventory[slot_number][0] = item_path.get_slot_info(1)
		itemlist.inventory[slot_number][1] = item_path.get_slot_info(2)
	#print(itemlist.inventory)

func inventory_load(): ###Загрузка инвентаря из itemlist
	var button_path = get_node("GridContainer")
	for slot_number in range(itemlist.inventory.size()):
		slot(slot_number,itemlist.inventory[slot_number][0],itemlist.inventory[slot_number][1])
	use_menu_break()

	#inventory_reload(8) ###подгруз содержимого инвентаря
	
func inventory_reload(slot_limiter) -> void: ###конфигурация слота 
	for i in $GridContainer.get_child_count():
		if i < slot_limiter:
			slot(i,0,1)
		else:
			slot(i,-1,1)
	inventory_save()

func slotnum(slot_number:int) -> void:
	if last_button == 1 and !menu_toggle: ##левая кнопка мыши
		hide_discr(slot_number)
		var button_path = get_node("GridContainer")
		var item_path = button_path.get_child(slot_number).get_child(0).get_child(1)
		if mousetoggle == true: ##запоминается айди в руку
			mouse_toggle()
			$mouse_equip_item.visible = true
			selected_slot_id_start = item_path.get_slot_info(1)
			selected_slot_start_count = item_path.get_slot_info(2)
			match selected_slot_id_start:
				-1:
					reset_variable()
					$mouse_equip_item.texture = itemlist.itemlist[0]["TEXTURE"]
				0:
					$mouse_equip_item.texture = itemlist.itemlist[0]["TEXTURE"]
					reset_variable()
				_:
					$mouse_equip_item.texture = itemlist.itemlist[selected_slot_id_start]["TEXTURE"]
					selected_slot_start = slot_number
					slot(selected_slot_start,0,selected_slot_start_count)
		elif mousetoggle == false:
			mouse_toggle()
			selected_slot_end = slot_number
			selected_slot_id_end = item_path.get_slot_info(1)
			selected_slot_end_count = item_path.get_slot_info(2)
			
			if selected_slot_start == selected_slot_end: ##перенос туда же
				slot(selected_slot_start,selected_slot_id_start,selected_slot_start_count)
			else:
				match selected_slot_id_end:
					-1: ## перенос на закрытый слот
						slot(selected_slot_start,selected_slot_id_start,selected_slot_start_count)
					selected_slot_id_start:  ## перенос на аналогичный слот
						var newcount = selected_slot_start_count+selected_slot_end_count
						slot(selected_slot_end,selected_slot_id_start,newcount)
						slot(selected_slot_start,0,1)
					_: ##перенос на доступный слот
						slot(selected_slot_end,selected_slot_id_start,selected_slot_start_count)
						slot(selected_slot_start,selected_slot_id_end,selected_slot_end_count)
			$mouse_equip_item.visible = false
			inventory_save()
			reset_variable()
	if last_button == 2: ##правая кнопка мыши
		use_menu(slot_number,false)
		

	

func slot(slot_number,num,count) -> void: ###Редактирование слота (Технический)
	var button_path = get_node("GridContainer")
	var item_path = button_path.get_child(slot_number).get_child(0).get_child(1)
	item_path.slot(num,count)

	
func _input(_event): ###перемещение под указателем (Технический)
	$mouse_equip_item.global_position = get_global_mouse_position()-Vector2(40,30)		
	if _event is InputEventMouseButton and _event.pressed:
		last_button = _event.button_index
		match _event.button_index:
			1:
				pass
			_:
				use_menu_break()
		
func inventory_toggle(): ###Анимация вкл/выкл (Технический)
	if !open:
		show_animation.play("inventory_show_animation")
		open = true
		global.attack_block = true
	else:
		open = false
		global.attack_block = false
		show_animation.play_backwards("inventory_show_animation")

#############################################################################
#############################################################################
#############################################################################


func reset_variable(): ###Cброс переменных (Технический)
	selected_slot_id_start = 0
	selected_slot_start = 0
	selected_slot_id_end = 0
	selected_slot_end = 0
	mousetoggle = true		

		
func mouse_toggle(): ###
	if mousetoggle == true:
		mousetoggle = false
	else:
		mousetoggle = true		


	
##################SAVE####################


	


###################Содержимое инвентаря###################


	#random_items_in_slots()
	#itemlist.inventory = itemlist.inventory_storage[inventory_lvl]




##фидбек кнопки - Возвращает что за предмет в слоте ID

###заполнение руки






## рандомное заполнение
func random_items_in_slots():
	var slotnumber = 0
	while slotnumber < 16:
		slot(slotnumber,randi_range(0,4),randi_range(1,4))
		slotnumber = slotnumber + 1
