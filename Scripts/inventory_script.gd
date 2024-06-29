extends Control

class_name inventory

var open = true
@onready var show_animation = $inventory_pos_animation

var selected_slot_start: int = -1
var selected_slot_id_start: int = -1
var selected_slot_end: int = -1
var selected_slot_id_end: int = -1
var mousetougle: bool = false
func _ready():
	print("inventory_started - inventory_script")
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
		random_items_in_slots()	
	#debug()


func debug():
	print("Start: Слот №" +str(selected_slot_start) +" предмет № " +str(selected_slot_id_start))
	print("End: Слот № "+str(selected_slot_end) +" предмет № " +str(selected_slot_id_end))
	print("Рука: Слот № "+str(selected_slot_end)+" предмет № " +str(selected_slot_id_start))
	print("________________________________________________________________________")
func mouse_tougle():
	if mousetougle == false and open == false:
		mousetougle = true
		$mouse_equip_item.visible = true
	elif mousetougle == true and open == false:
		if selected_slot_start != selected_slot_end and selected_slot_id_start != selected_slot_id_end:
			slot(selected_slot_start,selected_slot_id_end)
			slot(selected_slot_end,selected_slot_id_start)
		if selected_slot_id_start == selected_slot_id_end:
			pass
			
		mousetougle = false
		$mouse_equip_item.visible = false
	
func _input(event):
	if event is InputEventMouseButton:
		mouse_tougle()

	if event is InputEventMouseMotion:
		
		#print("Предмет = "+str(selected_slot_id_end)+ " слот = "+ str(selected_slot_end))
		
		$mouse_equip_item.global_position = event.position	
################################################


###############################################






## рандомное заполнениеsd
func random_items_in_slots():
	var slotnumber = 0
	while slotnumber != 16:
		slotnumber = slotnumber + 1
		slot(slotnumber,randi_range(0,4))
	






##Редактирование слота
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
func slot1():
	var slotid = $GridContainer/Slot1/Button/Item1.get_slot_info()
	selected_slot_id_start = slotid
	selected_slot_start = 1
	#print("слот 1 - " + str(slotid))
func slot2():
	var slotid = $GridContainer/Slot2/Button/Item2.get_slot_info()
	selected_slot_id_start = slotid
	selected_slot_start = 2
	#print("слот 2 - " + str(slotid))
func slot3():
	var slotid = $GridContainer/Slot3/Button/Item3.get_slot_info()
	selected_slot_id_start = slotid
	selected_slot_start = 3
	#print("слот 3 - " + str(slotid))
func slot4():
	var slotid = $GridContainer/Slot4/Button/Item4.get_slot_info()
	selected_slot_id_start = slotid
	selected_slot_start = 4
	#print("слот 4 - " + str(slotid))
func slot5():
	var slotid = $GridContainer/Slot5/Button/Item5.get_slot_info()
	selected_slot_id_start = slotid
	selected_slot_start = 5
	#print("слот 5 - " + str(slotid))
func slot6():
	var slotid = $GridContainer/Slot6/Button/Item6.get_slot_info()
	selected_slot_id_start = slotid
	selected_slot_start = 6
	#print("слот 6 - " + str(slotid))
func slot7():
	var slotid = $GridContainer/Slot7/Button/Item7.get_slot_info()
	selected_slot_id_start = slotid
	selected_slot_start = 7
	#print("слот 7 - " + str(slotid))
func slot8():
	var slotid = $GridContainer/Slot8/Button/Item8.get_slot_info()
	selected_slot_id_start = slotid
	selected_slot_start = 8
	#print("слот 8 - " + str(slotid))
func slot9():
	var slotid = $GridContainer/Slot9/Button/Item9.get_slot_info()
	selected_slot_id_start = slotid
	selected_slot_start = 9
	#print("слот 9 - " + str(slotid))
func slot10():
	var slotid = $GridContainer/Slot10/Button/Item10.get_slot_info()
	selected_slot_id_start = slotid
	selected_slot_start = 10
	#print("слот 10 - " + str(slotid))
func slot11():
	var slotid = $GridContainer/Slot11/Button/Item11.get_slot_info()
	selected_slot_id_start = slotid
	
	selected_slot_start = 11
	#print("слот 11 - " + str(slotid))
func slot12():
	var slotid = $GridContainer/Slot12/Button/Item12.get_slot_info()
	selected_slot_id_start = slotid
	selected_slot_start = 12
	#print("слот 12 - " + str(slotid))
func slot13():
	var slotid = $GridContainer/Slot13/Button/Item13.get_slot_info()
	selected_slot_id_start= slotid
	selected_slot_start = 13
	#print("слот 13 - " + str(slotid))
func slot14():
	var slotid = $GridContainer/Slot14/Button/Item14.get_slot_info()
	selected_slot_id_start = slotid
	selected_slot_start = 14
	#print("слот 14 - " + str(slotid))
func slot15():
	var slotid = $GridContainer/Slot15/Button/Item15.get_slot_info()
	selected_slot_id_start = slotid
	selected_slot_start = 15
	#print("слот 15 - " + str(slotid))
func slot16():
	var slotid = $GridContainer/Slot16/Button/Item16.get_slot_info()
	selected_slot_id_start = slotid
	selected_slot_start = 16
	#print("слот 16 - " + str(slotid))	

