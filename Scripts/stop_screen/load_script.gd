extends ScrollContainer

###СКРИПТ НА СОХРАНЕНИЕ/Загрузку
@onready var parent_node = $"../../.."
@onready var node = $".."
@onready var Rnode = $VBoxContainer
var savelist
var IFT:bool = false

func _ready():
	savelist = SaveScript.show_save_dir()

	
func _process(delta): 
	if node.visible and !IFT:
		IFT = true
		savelist = SaveScript.show_save_dir()
		refresh()
		connect_slot_buttons()
		
	
	elif !node.visible and IFT:
		IFT = false
		child_del()
	
func child_del(): ###Удаление fake слотов (Технический)
	if Rnode.get_child_count() != 0:
		for i in Rnode.get_child_count():
			var rdy_node = Rnode.get_child(0)
			Rnode.remove_child(rdy_node)	
	
func refresh(): ##Сканирует savelist на сохранения, создает слоты (Технический)
	var slot_num: int = 0
	for i in savelist:
		if i in savelist:
			print("найдено сохранение #",i)
			print(savelist[i])
			create_save_slot(slot_num,i)
			slot_num += 1
	connect_slot_buttons()
			
func create_save_slot(slotnum,i): ###Непостредственное создание и заполнение информацией слота
	####slotnum == номер сейва,записывается в лейбл
	####i = индекс сейва,записывается слева
	
	var path = $".".get_child(0)
	var slot = load("res://Scenes/stop_screen/save_slot.tscn").instantiate()
	path.add_child(slot)
	path.get_child(slotnum).name = "save_" + str(savelist[i][1]) ###название слота
	
	###определение расположения кнопок
	
	path.get_child(slotnum).slot_id = i
	path.get_child(slotnum).slot_num = slotnum
	
	var label1 = path.get_child(slotnum).get_child(1).get_child(0) ##название сейва место
	var label2 = path.get_child(slotnum).get_child(1).get_child(1) ##имя профиля
	var label3 = path.get_child(slotnum).get_child(1).get_child(2).get_child(0) ##HP
	var label4 = path.get_child(slotnum).get_child(1).get_child(2).get_child(1) ##Coins
	var label5 = path.get_child(slotnum).get_child(1).get_child(2).get_child(2) ##keys

	var label1_text = str(savelist[i][2])
	var label2_text = str(savelist[i][1])
	var label3_text = "hp " + str(savelist[i][3]) 
	var label4_text = "coins: " + str(savelist[i][4])
	var label5_text = "keys " + str(savelist[i][5])
	
	label1.text = label1_text
	label2.text = label2_text
	label3.text = label3_text
	label4.text = label4_text
	label5.text = label5_text
	
	if str(savelist[i][1]) == "" or str(savelist[i][1]) == " ": ###Исключения
		label2.text = "no_name"


func connect_slot_buttons(): ###подключение кнопок
	for i in Rnode.get_child_count():
		var button_dir = Rnode.get_child(i).get_child(3)
		var load_button = button_dir.get_child(0)
		var del_button = button_dir.get_child(1)
		load_button.connect("button_up",Callable(self, "load_button").bind(i))
		del_button.connect("button_up",Callable(self, "del_button").bind(i))
		#print(button_load.name)
	
func load_button(i:int):
	var slot_id = Rnode.get_child(i).slot_id
	var result: bool = false
	result = await $"../../confirm_panel".confirm_show("LOAD SAVE?")
	if result:
		SaveScript.load_game(slot_id)

func del_button(i:int):
	var slot_id = Rnode.get_child(i).slot_id
	var result: bool = false
	result = await $"../../confirm_panel".confirm_show("ARE YOU SHOORE123?")
	if result:
		SaveScript.delete_save(slot_id)
	savelist = SaveScript.show_save_dir()
	child_del()
	refresh()
	print("Удаление слота: ",slot_id)
	
	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
