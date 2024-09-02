extends Control

var console_visible = false

@onready var window = $"."
@onready var settings_menu = $CanvasLayer/control_module/settings_menu
@onready var main_menu = $CanvasLayer/control_module/main_menu
@onready var delay_timer = $CanvasLayer/control_module/DelayTimer
@onready var console_node = $CanvasLayer/console
@onready var console_line = $CanvasLayer/control_module/console/LineEdit
@onready var keybinds_slider = $CanvasLayer/control_module/settings_menu/brightness/slider
@onready var keybinds_slider_lable = $CanvasLayer/control_module/settings_menu/brightness/slider_lable
@onready var keymap_menu = $CanvasLayer/control_module/settings_keybinds
@onready var window_menu = $CanvasLayer/control_module/settings_window


var active_resolution
const resolution_list:Dictionary = {
	####width,height,interface_scale
	1: [500,500,0.4,250,825],
	2: [1200,800,0.7,600,675],
	3: [1600,1000,0.84,800,575],
	4: [1920,1080,1,960,540],
	5: [2048,1080,1,250,825],
	6: [2940, 1780,1.53,1475,1100]
}

###Window_Settings####

@onready var window_res_slider= $CanvasLayer/control_module/settings_window/button_list/button_list/in_settings_buttons/resolution/HSlider
@onready var window_res_label = $CanvasLayer/control_module/settings_window/button_list/button_list/in_settings_buttons/resolution/Label
#@onready var keymap_menu = $CanvasLayer/control_module/settings_keybinds
#@onready var keymap_menu = $CanvasLayer/control_module/settings_keybinds

func _ready():
	####main_menu####
	global.del_scene("hud")
	print(get_viewport().size)
	var continue_but = $CanvasLayer/control_module/main_menu/first_line_stop_menu/main/Button_Continue
	continue_but.connect("button_up",continue_button)
	var settings_but = $CanvasLayer/control_module/main_menu/first_line_stop_menu/main/Button_Settings
	settings_but.connect("button_up",settings_button)
	var quit_but = $CanvasLayer/control_module/main_menu/first_line_stop_menu/main/Button_Quit
	quit_but.connect("button_up",quit_button)
	
	####settings_menu####
	
	var back_settings_but = $CanvasLayer/control_module/settings_menu/settings_menu/settings/Button_Back
	back_settings_but.connect("button_up",back_button)
	
	var keymap_settings_but = $CanvasLayer/control_module/settings_menu/in_settings_buttons/button_list/keymap/Button_KeyMap
	keymap_settings_but.connect("button_down",keymap_button)
	
	var window_settings_but = $CanvasLayer/control_module/settings_menu/in_settings_buttons/button_list/window/Button_Window
	window_settings_but.connect("button_down",window_button)
	
	####keymap######
	var back_keymap_but = $CanvasLayer/control_module/settings_keybinds/settings_menu/settings/Button_Back
	back_keymap_but.connect("button_down",keymap_back_button)
	
	###window####
	
	var back_window_but = $CanvasLayer/control_module/settings_window/settings_menu/settings/Button_Back
	back_window_but.connect("button_down",window_back_button)
	
	var confirm_window_but = $CanvasLayer/control_module/settings_window/settings_menu/settings/Button_Confirm
	confirm_window_but.connect("button_down",window_confirm_button)
	
	var reset_window_but = $CanvasLayer/control_module/settings_window/settings_menu/settings/Button_Reset
	reset_window_but.connect("button_down",window_reset_button)
	
	window_res_slider.value = config.BASE_RES_NUM
	window_reset(config.BASE_RES_NUM)
	
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
			window_reset(config.TEMP_RES)
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

func window_reset_button2():
	var base_resolution = Vector2(1920,1080)
	DisplayServer.window_set_size(base_resolution)
	get_viewport().size = base_resolution
	$CanvasLayer/control_module.scale = Vector2(1,1)
	$CanvasLayer/control_module.position = Vector2(960,540) 
	
	get_tree().reload_current_scene()
	
func window_reset_button():
	var scaled = 1.53
	var res = 4
	var base_resolution = Vector2(resolution_list[res][0],resolution_list[res][1])
	var positioned = Vector2(1475,1100)
	global.del_scene("hud")
	DisplayServer.window_set_size(base_resolution)
	get_viewport().size = base_resolution
	$CanvasLayer/control_module.scale = Vector2(scaled,scaled)
	$CanvasLayer/control_module.position = positioned
	get_tree().reload_current_scene()	
	
func window_reset(res):
	var scaled = config.resolution_list[res][2]
	var resolution = Vector2(config.resolution_list[res][0],config.resolution_list[res][1])
	var positioned = Vector2(config.resolution_list[res][3],config.resolution_list[res][4])
	DisplayServer.window_set_size(resolution)
	get_viewport().size = resolution
	$CanvasLayer/control_module.scale = Vector2(scaled,scaled)
	$CanvasLayer/control_module.position = positioned
	get_tree().reload_current_scene()	
	
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
	var result = config.resolution_list[int(num)]
	var text = str(result[0],"x",result[1])
	window_res_label.text = text
	active_resolution = result

func window_confirm_button():
	##Размер окна
	var Screen_Size = Vector2(active_resolution[0], active_resolution[1])
	var Scale = Vector2(active_resolution[2],active_resolution[2])
	var Scaled_Position = Screen_Size/2
	
	

	
	DisplayServer.window_set_size(Screen_Size)
	get_viewport().size = Screen_Size
	$CanvasLayer/control_module.position = Vector2(Scaled_Position[0], Scaled_Position[1] + 200)
	#$CanvasLayer/control_module.position = Vector2(active_resolution[3],active_resolution[4])
	$CanvasLayer/control_module.scale = Scale


	print("Screen_Size: ",Screen_Size)
	print("Scale: ",Scale)
	print("Scaled_Position: ",Scaled_Position)
	print("control_module.position: ",$CanvasLayer/control_module.position)



	config.BASE_RES_NUM = window_res_slider.value
	get_tree().reload_current_scene()

	#print("size:2 ",num1," ",num2)
	#ProjectSettings.save()


