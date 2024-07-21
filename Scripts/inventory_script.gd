extends Control

class_name inventory

var open = false
@onready var show_animation = $inventory_pos_animation

var selected_slot_start: int = -1
var selected_slot_id_start: int = -1
var selected_slot_end: int = -1
var selected_slot_id_end: int = -1
var mousetougle: bool = true
var button_num: int
func _ready():
	print("inventory_started - inventory_script")
	inventory_info_storage(1)
	
	for num in get_node("GridContainer").get_child_count():
		#print(slotnum+1)
		num = num + 1
		var node_path: String = "GridContainer/Slot"+str(num)+"/Button"
		var button = get_node(node_path)
		button.connect("button_down",Callable(self, "slotnum").bind(num))

func inventory_tougle():
	if !open:
		open = true
		global.attack_block = true
		show_animation.play("inventory_show_animation")
	else:
		open = false
		global.attack_block = false
		show_animation.play_backwards("inventory_show_animation")	

func _process(_delta):
	if Input.is_action_just_released("special_tab"):
		inventory_tougle()
		print("inventory work - inventory_script")
	if Input.is_action_just_released("debug1"):
		inventory_info_storage(3)
#reset_variable()
#mousetougle = true
#debug()
	


func debug():
	print("Start: Слот №" +str(selected_slot_start) +" предмет № " +str(selected_slot_id_start))
	print("End: Слот № "+str(selected_slot_end) +" предмет № " +str(selected_slot_id_end))
	#print("Рука: Слот № "+str(selected_slot_end)+" предмет № " +str(selected_slot_id_start))
	print("mousetougle = " + str(mousetougle))
	print("________________________________________________________________________")

		#if open == false and selected_slot_start != selected_slot_end and selected_slot_id_start != selected_slot_id_end:
			
func mouse_touge():
	if mousetougle == true:
		#$mouse_equip_item.visible = true
		mousetougle = false
	else:
		#$mouse_equip_item.visible = false
		mousetougle = true
		#if selected_slot_start != selected_slot_end and selected_slot_id_start != selected_slot_id_end:
			#slot(selected_slot_start,selected_slot_id_end)
			#slot(selected_slot_end,selected_slot_id_start)
		#reset_variable()

func reset_variable():
	selected_slot_id_start = 0
	selected_slot_start = 0
	selected_slot_id_end = 0
	selected_slot_end = 0
	mousetougle = true

##################SAVE####################
#selected_slot_id_start = 0
#selected_slot_start = 0
#selected_slot_id_end = 0
#selected_slot_end = 0

#slot(selected_slot_start,selected_slot_id_end)
#slot(selected_slot_end,selected_slot_id_start)

################################################
func _input(_event):
	$mouse_equip_item.global_position = get_global_mouse_position()-Vector2(40,40)
###################Содержимое инвентаря###################

func inventory_info_storage(num1):
	var slotnumber = 1
	while slotnumber <= 16:
		slot(slotnumber,itemlist.inventory_storage[num1][slotnumber-1])
		slotnumber = slotnumber + 1
		
## рандомное заполнение
func random_items_in_slots():
	var slotnumber = 0
	while slotnumber != 16:
		slotnumber = slotnumber + 1
		slot(slotnumber,randi_range(0,4))

###################Редактирование слота###################
func slot(slot_number,num):
	var slotnum2 = str(slot_number)
	var node_path = "GridContainer/Slot" + slotnum2 + "/Button/Item" + slotnum2
	get_node(node_path).slot(num)

##фидбек кнопки - Возвращает что за предмет в слоте ID


func pickup(path,slotNum):
	if mousetougle == true: ##запоминается айди в руку
		mouse_touge()
		$mouse_equip_item.visible = true
		selected_slot_id_start = path.get_slot_info()
		if selected_slot_id_start == -1:
			reset_variable()
			$mouse_equip_item.texture = itemlist.itemlist[0][1]
		if selected_slot_id_start == 0:
			$mouse_equip_item.texture = itemlist.itemlist[0][1]
			reset_variable()
		else:
			$mouse_equip_item.texture = itemlist.itemlist[selected_slot_id_start][1]
			selected_slot_start = slotNum
			slot(selected_slot_start,0)
	elif mousetougle == false:
		mouse_touge()
		selected_slot_end = slotNum
		selected_slot_id_end = path.get_slot_info()
		if selected_slot_id_end == 0:
			slot(selected_slot_end,selected_slot_id_start)
		elif selected_slot_id_end == -1:
			slot(selected_slot_start,selected_slot_id_start)
			reset_variable()
		elif selected_slot_start == selected_slot_end:
			slot(selected_slot_start,selected_slot_id_start)
			reset_variable()
		else:
			slot(selected_slot_end,selected_slot_id_start)
			slot(selected_slot_start,selected_slot_id_end)
		$mouse_equip_item.visible = false
		reset_variable()


func slotnum(slot_number):
	var node_path = "GridContainer/Slot" + str(slot_number) + "/Button/Item" + str(slot_number)
	pickup(get_node(node_path),slot_number)
