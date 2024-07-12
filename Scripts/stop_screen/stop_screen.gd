extends Control

static var size1: float
var console_visible = false

@onready var window = $"."
@onready var settings_menu = $CanvasLayer/settings_menu
@onready var main_menu = $CanvasLayer/main_menu
@onready var delay_timer = $CanvasLayer/DelayTimer
@onready var console_node = $CanvasLayer/console
@onready var console_line = $CanvasLayer/console/LineEdit
@onready var slider = $CanvasLayer/settings_menu/brightness/slider
@onready var slider_lable = $CanvasLayer/settings_menu/brightness/slider_lable
@onready var keymap_menu = $CanvasLayer/settings_keybinds

func _ready():
	slider.value = global.brightness
	size1 = 1
	delay_timer.start(0.2)
	get_tree().paused = true
	show()
	
	$CanvasLayer/main_menu/first_line_stop_menu/main/Button_Continue.connect("button_up",continue_button)
	$CanvasLayer/main_menu/first_line_stop_menu/main/Button_Settings.connect("button_up",settings_button)
	$CanvasLayer/main_menu/first_line_stop_menu/main/Button_Quit.connect("button_up",quit_button)
	$CanvasLayer/settings_menu/settings_menu/settings/Button_Back.connect("button_up",back_button)
	$CanvasLayer/settings_menu/in_settings_buttons/settings/Button_KeyMap.connect("button_down",keymap_button)
	$CanvasLayer/settings_keybinds/settings_menu/settings/Button_Back.connect("button_down",keymap_back_button)
	#$GridContainer/Slot5/Button.connect("button_down",slot5)

enum {
	GET,
	SET,
	key,
	coin,
	hp,
}	
	
func set_view_size():
	match global.get_camera_position(2)[0]:
		1.5:
			size1 = 1.34
		2.0:
			size1 = 1
		2.5:
			size1 = 0.8
	window.scale = Vector2(size1,size1)
	
func _process(_delta):
	#debug()
	brightness_slider()
	
	if delay_timer.is_stopped() == true:
		if Input.is_action_just_released("special_back") and !global.buttons_lock:
			get_tree().paused = false
			global.del_scene("stop_screen")
		if Input.is_action_just_released("special_console") and !global.buttons_lock:
			console_tougle()
		if Input.is_action_just_released("enter") and console_visible == true and !global.buttons_lock:
			var command = str(console_line.get_text())
			Console(command)
			print("input:",command," - stop_screen")

func Console(text : String):
	text = text.lstrip(" ").rstrip(" ")
	var firstSpace : int = text.find(" ")
	var secondSpace : int = text.find(" ",firstSpace+1)
	#print("Дебаг0: ",secondSpace)
	var command : String
	var value1 : String
	var value2 : String
	if firstSpace == -1:
		command = text
	else:
		command = text.substr(0, firstSpace)
		value1 = text.substr(firstSpace+1,secondSpace - firstSpace-1)
		value2 = text.substr(secondSpace+1,len(text))
		#value2 = text.substr(secondSpace+1,thirdSpace - secondSpace)
		#value3 = text.substr(thirdSpace+1,len(text))
		#print(command2[i])
	#print("Дебаг1: ",value1 + "-")
	#print("Дебаг2: ",value2)
	# Здесь можно добавить обработку команды teleport 500 500 или teleport 16 127
	#var split = command2.split(" ")
	#print((Vector2(split[1].to_int(), split[2].to_int())))
	console.input(str(command),value1,value2)#,value3)


func console_tougle():
	if console_visible == true:	 
		console_node.visible = false
		console_visible = false
	else:
		console_visible = true
		console_node.visible = true
func continue_button():
	get_tree().paused = false
	#get_tree().quit()
	global.del_scene("stop_screen")
func settings_button():
	main_menu.hide()
	settings_menu.show()

	##методы сбора информации в консоль
	print(OS.get)
	var size2 = "5000"
	ProjectSettings.set("application/config/name",size2)
	print(ProjectSettings.get_setting_with_override("application/config/name"))
	#ProjectSettings.set_setting_with_override("application/config/name")
func quit_button():
	get_tree().quit()

###settings menu
func back_button():
	settings_menu.hide()
	main_menu.show()
	
func keymap_button():
	global.buttons_lock = true
	settings_menu.hide()
	keymap_menu.show()	
	
func keymap_back_button():
	global.buttons_lock = false
	settings_menu.show()
	keymap_menu.hide()		
	
func brightness_slider():
	global.brightness = slider.value
	slider_lable.text = "brightness: "+str(slider.value)
	#get_tree().paused = true	
