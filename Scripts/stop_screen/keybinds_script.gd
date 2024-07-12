extends ScrollContainer

var key_pressed = null
var listing = 0
var active_button = null
var button_pressed = false
var keybinds = {}
var key_value = {
	0: ["0", 48],
	1: ["1", 49],
	2: ["2", 50],
	3: ["3", 51],
	4: ["4", 52],
	5: ["5", 53],
	6: ["6", 54],
	7: ["7", 55],
	8: ["8", 56],
	9: ["9", 57],
	10: ["a", 65],
	11: ["b", 66],
	12: ["c", 67],
	13: ["d", 68],
	14: ["e", 69],
	15: ["f", 70],
	16: ["g", 71],
	17: ["h", 72],
	18: ["i", 73],
	19: ["j", 74],
	20: ["k", 75],
	21: ["l", 76],
	22: ["m", 77],
	23: ["n", 78],
	24: ["o", 79],
	25: ["p", 80],
	26: ["q", 81],
	27: ["r", 82],
	28: ["s", 83],
	29: ["t", 84],
	30: ["u", 85],
	31: ["v", 86],
	32: ["w", 87],
	33: ["x", 88],
	34: ["y", 89],
	35: ["z", 90],
	36: ["F1", 16777238],
	37: ["F2", 16777239],
	38: ["F3", 16777240],
	39: ["F4", 16777241],
	40: ["F5", 16777242],
	41: ["F6", 16777243],
	42: ["F7", 16777244],
	43: ["F8", 16777245],
	44: ["F9", 16777246],
	45: ["F10", 16777247],
	46: ["F11", 16777248],
	47: ["F12", 16777249],
	48: ["Escape", 16777217],
	49: ["Tab", 16777218],
	50: ["Backspace", 16777219],
	51: ["enter", 4194309],
	52: ["shift", 4194325],
	53: ["control", 4194326],
	54: ["Alt", 16777223],
	55: ["Space", 32],
	56: ["Left Arrow", 16777234],
	57: ["Up Arrow", 16777235],
	58: ["Right Arrow", 16777236],
	59: ["Down Arrow", 16777237],
	60: ["~", 96],
	61: ["minus", 45],
	62: ["plus", 61],
	63: ["esc", 4194305],
	64: ["insert", 228]
}
func _ready():
	set_process_input(false)
	keybinds = itemlist.keybinds
	refresh()

func _process(delta):
	reout()

		
func reout(): ##выводит содержимое не переопределяя ечейки, простой вывод новой инфы
	var path = $".".get_child(0)
	for i in len(keybinds):
		path.get_child(i).name = keybinds[i][0]
		path.get_child(i).get_child(1).text = keybinds[i][0] ##заполение текста в label
		for f in len(key_value):
			if key_value[f][1] == keybinds[i][1]:
				path.get_child(i).get_child(2).text = str(key_value[f][0]) ##заполение текста в button
		
func refresh(): ##выводит содержимое переопределяя ечейки
	var path = $".".get_child(0)
	
	for i in len(keybinds):
		var slot = load("res://Scenes/stop_screen/keybind_slot.tscn").instantiate()
		path.add_child(slot)
		path.get_child(i).name = keybinds[i][0]
		var label = path.get_child(i).get_child(1)
		var button = path.get_child(i).get_child(2)
		label.text = keybinds[i][0] ##заполение текста в label
		for f in len(key_value):
			if key_value[f][1] == keybinds[i][1]:
				button.text = str(key_value[f][0]) ##заполение текста в button
		button.connect("button_up",Callable(self, "update_button_text").bind(keybinds[i][0]))
	itemlist.keybinds = keybinds
		
##input - имя объекта пример - "special_use"
##new_key - кнопка - пример - KEY_UP
func remap_key(input,new_key):
	print("input: ",input," new_key: ",new_key)
	InputMap.erase_action(str(input))
	InputMap.add_action(str(input))
	var key_event = InputEventKey.new()
	####назначение в настройки проекта
	key_event.physical_keycode = new_key
	InputMap.action_add_event(str(input), key_event)
	##назначение в таблицу
	for i in len(keybinds):
		if keybinds[i][2] == str(input): #нахождение в таблице какой раздел клавиши
			print("До изменений:",keybinds[i][1], "|", key_value[i][1])
			keybinds[i][1] = new_key #присвоение в таблицу значения 
			print("После изменений:",keybinds[i][1], "|", key_value[i][1])
			#print(keybinds[i][1])


func _input(event):
	if event is InputEventKey and event.pressed:
		if active_button != null and listing != null:
			key_pressed = event.keycode
			##print("Клавиша записана:", key_pressed)
			remap_key(active_button,key_pressed)
		set_process_input(false)
		active_button = null
		listing = null

func update_button_text(button):
	for i in len(keybinds):
		if button == keybinds[i][0]:
			listing = i
			active_button = keybinds[i][2]
			remap_key(active_button,228)
			set_process_input(true)
			
			
		
	
