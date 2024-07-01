extends Control

class_name inventory

var open = true
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
	
	
	$GridContainer/Slot1/Button.connect("button_down",slot1)
	$GridContainer/Slot2/Button.connect("button_down",slot2)
	$GridContainer/Slot3/Button.connect("button_down",slot3)
	$GridContainer/Slot4/Button.connect("button_down",slot4)
	$GridContainer/Slot5/Button.connect("button_down",slot5)
	$GridContainer/Slot6/Button.connect("button_down",slot6)
	$GridContainer/Slot7/Button.connect("button_down",slot7)
	$GridContainer/Slot8/Button.connect("button_down",slot8)
	$GridContainer/Slot9/Button.connect("button_down",slot9)
	$GridContainer/Slot10/Button.connect("button_down",slot10)
	$GridContainer/Slot11/Button.connect("button_down",slot11)
	$GridContainer/Slot12/Button.connect("button_down",slot12)
	$GridContainer/Slot13/Button.connect("button_down",slot13)
	$GridContainer/Slot14/Button.connect("button_down",slot14)
	$GridContainer/Slot15/Button.connect("button_down",slot15)
	$GridContainer/Slot16/Button.connect("button_down",slot16)

func inventory_tougle():
	if open:
		open = false
		show_animation.play("inventory_show_animation")
	else:
		open = true
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
func _input(event):
	if event is InputEventMouseMotion:
		$mouse_equip_item.global_position = event.position	
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
func slot(slotnum,num):
	match slotnum:
		1:
			$GridContainer/Slot1/Button/Item1.slot(num)
		2:
			$GridContainer/Slot2/Button/Item2.slot(num)
		3:
			$GridContainer/Slot3/Button/Item3.slot(num)
		4:
			$GridContainer/Slot4/Button/Item4.slot(num)
		5:
			$GridContainer/Slot5/Button/Item5.slot(num)
		6:
			$GridContainer/Slot6/Button/Item6.slot(num)
		7:
			$GridContainer/Slot7/Button/Item7.slot(num)
		8:
			$GridContainer/Slot8/Button/Item8.slot(num)
		9:
			$GridContainer/Slot9/Button/Item9.slot(num)
		10:
			$GridContainer/Slot10/Button/Item10.slot(num)
		11:
			$GridContainer/Slot11/Button/Item11.slot(num)
		12:
			$GridContainer/Slot12/Button/Item12.slot(num)
		13:
			$GridContainer/Slot13/Button/Item13.slot(num)
		14:
			$GridContainer/Slot14/Button/Item14.slot(num)
		15:
			$GridContainer/Slot15/Button/Item15.slot(num)
		16:
			$GridContainer/Slot16/Button/Item16.slot(num)

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
		if selected_slot_id_end == -1:
			slot(selected_slot_start,selected_slot_id_start)
			reset_variable()
		else:
			slot(selected_slot_end,selected_slot_id_start)
			slot(selected_slot_start,selected_slot_id_end)
		$mouse_equip_item.visible = false
		reset_variable()

func slot1():
	var slotNum = 1
	var path = $GridContainer/Slot1/Button/Item1
	pickup(path,slotNum)
func slot2():
	var slotNum = 2
	var path = $GridContainer/Slot2/Button/Item2
	pickup(path,slotNum)
func slot3():
	var slotNum = 3
	var path = $GridContainer/Slot3/Button/Item3
	pickup(path,slotNum)
func slot4():
	var slotNum = 4
	var path = $GridContainer/Slot4/Button/Item4
	pickup(path,slotNum)
func slot5():
	var slotNum = 5
	var path = $GridContainer/Slot5/Button/Item5
	pickup(path,slotNum)
func slot6():
	var slotNum = 6
	var path = $GridContainer/Slot6/Button/Item6
	pickup(path,slotNum)
func slot7():
	var slotNum = 7
	var path = $GridContainer/Slot7/Button/Item7
	pickup(path,slotNum)
func slot8():
	var slotNum = 8
	var path = $GridContainer/Slot8/Button/Item8
	pickup(path,slotNum)
func slot9():
	var slotNum = 9
	var path = $GridContainer/Slot9/Button/Item9
	pickup(path,slotNum)
func slot10():
	var slotNum = 10
	var path = $GridContainer/Slot10/Button/Item10
	pickup(path,slotNum)
func slot11():
	var slotNum = 11
	var path = $GridContainer/Slot11/Button/Item11
	pickup(path,slotNum)
func slot12():
	var slotNum = 12
	var path = $GridContainer/Slot12/Button/Item12
	pickup(path,slotNum)
func slot13():
	var slotNum = 13
	var path = $GridContainer/Slot13/Button/Item13
	pickup(path,slotNum)
func slot14():
	var slotNum = 14
	var path = $GridContainer/Slot14/Button/Item14
	pickup(path,slotNum)
func slot15():
	var slotNum = 15
	var path = $GridContainer/Slot15/Button/Item15
	pickup(path,slotNum)
func slot16():
	var slotNum = 16
	var path = $GridContainer/Slot16/Button/Item16
	pickup(path,slotNum)

