extends CanvasLayer

var console_visible = false

var temp_delay: bool

@onready var window = $"."
@onready var settings_menu = $control_module/settings_menu
@onready var main_menu = $control_module/main_menu
@onready var delay_timer = $control_module/DelayTimer
@onready var console_node = $control_module/console
@onready var console_line = $control_module/console/LineEdit
@onready var brightness_slider = $control_module/settings_menu/brightness/slider
@onready var brightness_slider_lable = $control_module/settings_menu/brightness/slider_lable
@onready var keymap_menu = $control_module/settings_keybinds
@onready var window_menu = $control_module/settings_window
@onready var load_menu = $control_module/load_menu
@onready var buton = $control_module/settings_window/button_list/button_list/in_settings_buttons/fullscreen/fscron
@onready var butoff = $control_module/settings_window/button_list/button_list/in_settings_buttons/fullscreen/fscroff
var active_resolution

###Window_Settings####

@onready var window_res_slider= $control_module/settings_window/button_list/button_list/in_settings_buttons/resolution/HSlider
@onready var window_res_label = $control_module/settings_window/button_list/button_list/in_settings_buttons/resolution/Label
@onready var settings_back = $control_module/settings
@onready var load_back = $control_module/load

func _ready():
	####main_menu####
	
	
	
	
	print(get_viewport().size)
	var continue_but = $control_module/main_menu/first_line_stop_menu/VBoxContainer/main/Button_Continue
	continue_but.connect("button_up",continue_button)
	var settings_but = $control_module/main_menu/first_line_stop_menu/VBoxContainer/main/Button_Settings
	settings_but.connect("button_up",settings_button)
	var load_but = $control_module/main_menu/first_line_stop_menu/VBoxContainer/main2/Button_Load
	load_but.connect("button_up",load_button)
	
	var quit_but = $control_module/main_menu/first_line_stop_menu/VBoxContainer/main2/Button_Quit
	quit_but.connect("button_up",quit_button)
	####load_menu####
	
	var back_load_but = $control_module/load_menu/settings_menu/settings/Button_Back
	back_load_but.connect("button_up",load_back_button)
	
	
	####settings_menu####
	
	var back_settings_but = $control_module/settings_menu/settings_menu/settings/Button_Back
	back_settings_but.connect("button_up",back_button)
	
	var keymap_settings_but = $control_module/settings_menu/in_settings_buttons/button_list/keymap/Button_KeyMap
	keymap_settings_but.connect("button_down",keymap_button)
	
	var window_settings_but = $control_module/settings_menu/in_settings_buttons/button_list/window/Button_Window
	window_settings_but.connect("button_down",window_button)
	
	####keymap######
	var back_keymap_but = $control_module/settings_keybinds/settings_menu/settings/Button_Back
	back_keymap_but.connect("button_down",keymap_back_button)
	
	###window####
	
	
	var fullscr_window_but_on = $control_module/settings_window/button_list/button_list/in_settings_buttons/fullscreen/fscron
	fullscr_window_but_on.connect("button_down",window_fscr_button_on)
	
	var fullscr_window_but_off = $control_module/settings_window/button_list/button_list/in_settings_buttons/fullscreen/fscroff
	fullscr_window_but_off.connect("button_down",window_fscr_button_off)
	
	
	var back_window_but = $control_module/settings_window/settings_menu/settings/Button_Back
	back_window_but.connect("button_down",window_back_button)
	
	var confirm_window_but = $control_module/settings_window/settings_menu/settings/Button_Confirm
	confirm_window_but.connect("button_down",window_confirm_button)
	
	var reset_window_but = $control_module/settings_window/settings_menu/settings/Button_Reset
	reset_window_but.connect("button_down",window_reset_button)
	
	window_res_slider.value = config.BASE_RES_NUM
	window_reset(config.BASE_RES_NUM)
	
	brightness_slider.value = global.brightness
	

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
	
	if global.buttons_lock and !temp_delay: ##если включается блокировка управления и делай выключен
		delay_timer.start(0.2)
		temp_delay = true #делай включается
	elif !global.buttons_lock and temp_delay: 
		temp_delay = false
	
	if delay_timer.is_stopped() == true:
		if Input.is_action_just_released("special_back"):# and global.buttons_lock:
			global.visible_scene("stop_screen",false)
			global.buttons_lock = false
			
			
		if Input.is_action_just_released("special_console"):# and !global.buttons_lock:
			#global.viv_scene_list()
			console_toggle()
			#window_reset_button()
		if Input.is_action_just_released("enter") and console_visible and global.buttons_lock:
			var command = str(console_line.get_text())
			var text = console_text_parse(command)
			console_line.set_text(text)
			await get_tree().create_timer(2).timeout
			console_line.set_text("")
			

func console_text_parse(text : String):
	var space = " "
	text = text.lstrip("").rstrip(space)
	var firstSpace : int = text.find(space)
	
	var secondSpace : int = text.find(space,firstSpace+1)
	var error_mode = false
	
	
	if secondSpace == -1:
		error_mode = true
	var command : String
	var value1 : String
	var value2 : String
	if firstSpace == -1:
		command = text
	else:
		command = text.substr(0, firstSpace)
	
		if !error_mode:
			value1 = text.substr(firstSpace+1,secondSpace - firstSpace-1)
			value2 = text.substr(secondSpace+1,len(text))
		else:
			value1 = text.substr(firstSpace+1,len(text))
			value2 = ""
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
	console_visible = false
	#temp_delay = false
	global.visible_scene("stop_screen",false)
	global.buttons_lock = false
	
func settings_button():
	main_menu.hide()
	settings_back.visible = true
	settings_menu.show()

func load_button():
	main_menu.hide()
	load_back.visible = true
	load_menu.show()

func quit_button():
	get_tree().quit()

###load menu###


func load_back_button():
	load_menu.hide()
	main_menu.show()
	load_back.visible = false

###settings menu

func back_button():
	settings_menu.hide()
	main_menu.show()
	settings_back.visible = false
	
func keymap_button():
	settings_menu.hide()
	keymap_menu.show()	

func window_button():
	settings_menu.hide()
	window_menu.show()	

func window_reset_button():
	var res = config.resolution_list[config.TEMP_RES]
	window_res_slider.value = config.TEMP_RES
	var Screen_Size = Vector2(res[0], res[1])
	var Scale = Vector2(res[2],res[2])
	
	$control_module.position = Vector2(res[3],res[4])
	$control_module.scale = Scale
	
	DisplayServer.window_set_size(Screen_Size)
	get_viewport().size = Screen_Size
	
func window_reset(res):
	var scaled = config.resolution_list[res][2]
	var resolution = Vector2(config.resolution_list[res][0],config.resolution_list[res][1])
	var positioned = Vector2(config.resolution_list[res][3],config.resolution_list[res][4])
	DisplayServer.window_set_size(resolution)
	get_viewport().size = resolution
	$control_module.scale = Vector2(scaled,scaled)
	$control_module.position = positioned
	
func window_back_button():
	settings_menu.show()
	window_menu.hide()		
	
func keymap_back_button():
	settings_menu.show()
	keymap_menu.hide()		
	
func settings_brightness_slider():
	global.brightness = brightness_slider.value
	if brightness_slider.value > 0.8:
		brightness_slider_lable.text = "debug_mode:  " + str(brightness_slider.value)
	else:
		brightness_slider_lable.text = "brightness:  "+str(brightness_slider.value)

func window_fscr_button_on():
	DisplayServer.window_set_mode(3)
	buton.disabled = true
	butoff.disabled = false

func window_fscr_button_off():
	DisplayServer.window_set_mode(0)
	
	buton.disabled = false
	butoff.disabled = true

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
	
	$control_module.position = Vector2(active_resolution[3],active_resolution[4])
	$control_module.scale = Scale
	
	
	DisplayServer.window_set_size(Screen_Size)
	get_viewport().size = Screen_Size

	print("Screen_Size: ",Screen_Size)
	print("Scale: ",Scale)
	print("control_module.position: ",$control_module.position)

	config.BASE_RES_NUM = window_res_slider.value
	
	SaveScript.config_save(window_res_slider.value,buton.disabled)


