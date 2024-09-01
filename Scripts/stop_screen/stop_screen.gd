extends Control

var console_visible = false

@onready var window = $"."
@onready var settings_menu = $CanvasLayer/settings_menu
@onready var main_menu = $CanvasLayer/main_menu
@onready var delay_timer = $CanvasLayer/DelayTimer
@onready var console_node = $CanvasLayer/console
@onready var console_line = $CanvasLayer/console/LineEdit
@onready var keybinds_slider = $CanvasLayer/settings_menu/brightness/slider
@onready var keybinds_slider_lable = $CanvasLayer/settings_menu/brightness/slider_lable
@onready var keymap_menu = $CanvasLayer/settings_keybinds
@onready var window_menu = $CanvasLayer/settings_window


var active_resolution
const resolution_list:Dictionary = {
	####width,height,interface_scale
	1: [500,500,0.1],
	2: [1200,800,0.6],
	3: [1600,1000,0.6],
	4: [1920,1080,1],
	5: [2048,1080,1.4],
	6: [2940, 1780,1.4]
}

###Window_Settings####

@onready var window_res_slider= $CanvasLayer/settings_window/button_list/button_list/in_settings_buttons/resolution/HSlider
@onready var window_res_label = $CanvasLayer/settings_window/button_list/button_list/in_settings_buttons/resolution/Label
#@onready var keymap_menu = $CanvasLayer/settings_keybinds
#@onready var keymap_menu = $CanvasLayer/settings_keybinds

func _ready():
	####main_menu####
	print(get_viewport().size)
	var continue_but = $CanvasLayer/main_menu/first_line_stop_menu/main/Button_Continue
	continue_but.connect("button_up",continue_button)
	var settings_but = $CanvasLayer/main_menu/first_line_stop_menu/main/Button_Settings
	settings_but.connect("button_up",settings_button)
	var quit_but = $CanvasLayer/main_menu/first_line_stop_menu/main/Button_Quit
	quit_but.connect("button_up",quit_button)
	
	####settings_menu####
	
	var back_settings_but = $CanvasLayer/settings_menu/settings_menu/settings/Button_Back
	back_settings_but.connect("button_up",back_button)
	
	var keymap_settings_but = $CanvasLayer/settings_menu/in_settings_buttons/button_list/keymap/Button_KeyMap
	keymap_settings_but.connect("button_down",keymap_button)
	
	var window_settings_but = $CanvasLayer/settings_menu/in_settings_buttons/button_list/window/Button_Window
	window_settings_but.connect("button_down",window_button)
	
	####keymap######
	var back_keymap_but = $CanvasLayer/settings_keybinds/settings_menu/settings/Button_Back
	back_keymap_but.connect("button_down",keymap_back_button)
	
	###window####
	
	var back_window_but = $CanvasLayer/settings_window/settings_menu/settings/Button_Back
	back_window_but.connect("button_down",window_back_button)
	
	var confirm_window_but = $CanvasLayer/settings_window/settings_menu/settings/Button_Confirm
	confirm_window_but.connect("button_down",window_confirm_button)
	get_tree().paused = true
	keybinds_slider.value = global.brightness
	delay_timer.start(0.2)

enum {
	GET,
	SET,
	key,
	coin,
	hp,
}	
	

func _process(_delta):
	settings_brightness_slider()
	window_resolution_slider()
	if delay_timer.is_stopped() == true:
		if Input.is_action_just_released("special_back") and !global.buttons_lock:
			get_tree().paused = false
			global.del_scene("stop_screen")
		if Input.is_action_just_released("special_console") and !global.buttons_lock:
			console_toggle()
		if Input.is_action_just_released("enter") and console_visible and !global.buttons_lock:
			var command = str(console_line.get_text())
			var text = console_text_parse(command)
			console_line.set_text(text)
			await get_tree().create_timer(2).timeout
			console_line.set_text("")
			

func console_text_parse(text : String):
	text = text.lstrip(" ").rstrip(" ")
	var firstSpace : int = text.find(" ")
	var secondSpace : int = text.find(" ",firstSpace+1)
	var command : String
	var value1 : String
	var value2 : String
	if firstSpace == -1:
		command = text
	else:
		command = text.substr(0, firstSpace)
		value1 = text.substr(firstSpace+1,secondSpace - firstSpace-1)
		value2 = text.substr(secondSpace+1,len(text))
	var text2
	if value1 == null:
		text2 = "input_error"
		return text2
	return console.input(str(command),value1,value2)

func console_toggle():
	if console_visible:	 
		console_visible = false
	else:
		console_visible = true
	console_node.visible = console_visible	
	
func continue_button():
	get_tree().paused = false
	global.del_scene("stop_screen")
	
func settings_button():
	main_menu.hide()
	settings_menu.show()

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

func window_button():
	global.buttons_lock = true
	settings_menu.hide()
	window_menu.show()	

	
func window_back_button():
	global.buttons_lock = false
	settings_menu.show()
	window_menu.hide()		
	
func keymap_back_button():
	global.buttons_lock = false
	settings_menu.show()
	keymap_menu.hide()		


	
func settings_brightness_slider():
	global.brightness = keybinds_slider.value
	keybinds_slider_lable.text = "brightness: "+str(keybinds_slider.value)

func window_resolution_slider():
	var num = window_res_slider.value
	var result = resolution_list[int(num)]
	var text = str(result[0],"x",result[1])
	window_res_label.text = text
	active_resolution = result
	#global.brightness = window_res_slider.value
	
func window_confirm_button():
	##Позиция окна
	get_viewport().position = Vector2i(0,0)
	##Разамер окна
	var num1 = active_resolution[0]
	var num2 = active_resolution[1]
	
	
	print("a_r0: ",active_resolution[0])
	print("a_r1: ",active_resolution[1])
	
	var Screen_Size = Vector2i(num1,num2)
	var Scale = Vector2(active_resolution[2],active_resolution[2])
	var Scaled_Position = Screen_Size/2
	#print(DisplayServer.screen_get_size())
	#get_tree().screen_get_size
	#get_viewport().size = DisplayServer.screen_get_size()
	#DisplayServer.window_set_size(Vector2i(num1,num2))
	
	$".".position = Scaled_Position 
	$CanvasLayer.scale = Scale
	
	DisplayServer.window_set_size(Screen_Size)
	get_viewport().size = Screen_Size
	#print("размер экрана: ",)
	
	
	get_tree().reload_current_scene()
	print("size:1 ",get_viewport().size)
	print("size:2 ",num1," ",num2)
	#ProjectSettings.save()


