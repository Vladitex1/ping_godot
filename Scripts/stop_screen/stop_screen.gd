extends Control


@onready var window = $"."
@onready var main_menu = $CanvasLayer
@onready var delay_timer = $CanvasLayer/DelayTimer
<<<<<<< Updated upstream
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
=======
var console_visible: bool = true
>>>>>>> Stashed changes

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
	
	get_tree().paused = true
	delay_timer.start(0.2)

func _process(_delta):
	if global.mm_hide == true:
		main_menu.hide()
		global.buttons_lock = true
	else:
		main_menu.show()
		global.buttons_lock = false
		
	if delay_timer.is_stopped() and Input.is_action_just_released("special_back") and !global.buttons_lock:
		continue_button()
	if Input.is_action_just_released("special_console"):
		console_toggle()
	
func continue_button():
	print("консоль выкл")
	console_visible = true
	global.del_scene("console")
	
	get_tree().paused = false
	global.del_scene("stop_screen")
	
func settings_button():
	global.add_scene("settings")
	main_menu.hide()

func quit_button():
	get_tree().quit()

func console_toggle():
	for i in get_tree().root.get_child_count():
		print(get_tree().root.get_child(i).name)
	
	print("____")
	
<<<<<<< Updated upstream
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


=======
	match console_visible:
		true:
			print("консоль вкл")
			console_visible = false
			global.add_scene("console")
		false:
			print("консоль выкл")
			console_visible = true
			global.del_scene("console")
>>>>>>> Stashed changes
