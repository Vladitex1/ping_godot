extends CanvasLayer

@onready var window_res_slider= $settings_window/button_list/button_list/in_settings_buttons/resolution/HSlider
@onready var window_res_label = $settings_window/button_list/button_list/in_settings_buttons/resolution/Label
@onready var brightness_slider = $settings_menu/brightness/slider
@onready var brightness_slider_lable = $settings_menu/brightness/slider_lable
@onready var settings_menu = $settings_menu
@onready var keymap_menu = $settings_keybinds
@onready var window_menu = $settings_window




var active_resolution
const resolution_list:Dictionary = {
	1: [1000,700],
	2: [1200,800],
	3: [1600,1000],
	4: [1920,1080],
	5: [2048,1080],
	6: [2940, 1912]
}

func _ready():
	
	var back_but = $settings_menu/settings_menu/settings/Button_Back
	back_but.connect("button_up",back_button)
	
	var keymap_but = $settings_menu/in_settings_buttons/button_list/keymap/Button_KeyMap
	keymap_but.connect("button_up",keymap_button)
	
	var window_but = $settings_menu/in_settings_buttons/button_list/window/Button_Window
	window_but.connect("button_up",window_button)
	
	var keymap_back_but = $settings_keybinds/settings_menu/settings/Button_Back
	keymap_back_but.connect("button_up",keymap_back_button)
	
	var window_fullscreen_but = $settings_window/button_list/button_list/in_settings_buttons/fullscreen/Button
	#window_fullscreen_but.connect("button_up",continue_button)
	
	var window_confirm_but = $settings_window/settings_menu/settings/Button_Confirm
	window_confirm_but.connect("button_up",window_confirm_button)
	
	var window_back_but = $settings_window/settings_menu/settings/Button_Back
	window_back_but.connect("button_up",window_back_button)
	brightness_slider.value = global.brightness
	
	global.mm_hide = true
	
	

func _process(delta):
	window_resolution_slider()
	settings_brightness_slider()
	if Input.is_action_just_released("special_back") and !global.buttons_lock:
		back_button()
func back_button():
	global.del_scene("settings")
	global.mm_hide = false
	
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
	global.brightness = brightness_slider.value
	brightness_slider_lable.text = "brightness: "+str(brightness_slider.value)

func window_resolution_slider():
	var num = window_res_slider.value
	var result = resolution_list[int(num)]
	var text = str(result[0],"x",result[1])
	window_res_label.text = text
	active_resolution = result
	#global.brightness = window_res_slider.value
	
func window_confirm_button():
	var num1 = active_resolution[0]
	var num2 = active_resolution[1]
	#print(DisplayServer.screen_get_size())
	#get_tree().screen_get_size
	get_viewport().position = Vector2i(0,0)
	get_viewport().size = Vector2i(num1,num2)
	#print(get_viewport().size)
	#get_tree().viewport.set_size(Vector2i(num1,num2))
	#ProjectSettings.save()


