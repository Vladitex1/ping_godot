extends Control

@onready var window_res_slider: HSlider = $button_list/button_list/in_settings_buttons/resolution/HSlider
@onready var window_res_label: Label = $button_list/button_list/in_settings_buttons/resolution/Label
@onready var brightness_slider: HSlider = $button_list/button_list/in_settings_buttons/brightness/slider
@onready var brightness_slider_lable: Label = $button_list/button_list/in_settings_buttons/brightness/slider_lable
@onready var buton = $button_list/button_list/in_settings_buttons/fullscreen/fscron
@onready var butoff = $button_list/button_list/in_settings_buttons/fullscreen/fscroff
@onready var control_module = $".."



var active_resolution


func _ready() -> void: 
	
	buton.connect("button_down",Callable(self, "window_fscr_button").bind(true))
	butoff.connect("button_down",Callable(self, "window_fscr_button").bind(false))
	
	var back_window_but = $settings_menu/settings/Button_Back
	back_window_but.connect("button_down",window_back_button)
	
	var confirm_window_but = $settings_menu/settings/Button_Confirm
	confirm_window_but.connect("button_down",window_confirm_button)
	
	var reset_window_but = $settings_menu/settings/Button_Reset
	reset_window_but.connect("button_down",window_reset_button)
	
	window_res_slider.value = config.BASE_RES_NUM
	brightness_slider.value = global.brightness
	
	window_reset(config.BASE_RES_NUM)
	
func _process(delta):
	settings_brightness_slider()
	window_resolution_slider()

func window_back_button(): #####################################################
	global.get_global_scene("stop_screen").select_menu("settings")	

func window_reset_button(): ####################################################
	var res = config.resolution_list[config.TEMP_RES]
	window_res_slider.value = config.TEMP_RES
	var Screen_Size = Vector2(res[0], res[1])
	var Scale = Vector2(res[2],res[2])
	
	control_module.position = Vector2(res[3],res[4])
	control_module.scale = Scale
	
	DisplayServer.window_set_size(Screen_Size)
	get_viewport().size = Screen_Size
	
func window_reset(res):#########################################################
	var scaled = config.resolution_list[res][2]
	var resolution = Vector2(config.resolution_list[res][0],config.resolution_list[res][1])
	var positioned = Vector2(config.resolution_list[res][3],config.resolution_list[res][4])
	DisplayServer.window_set_size(resolution)
	get_viewport().size = resolution
	control_module.scale = Vector2(scaled,scaled)
	control_module.position = positioned
	
func window_fscr_button(turnONoff):#############################################
	match turnONoff:
		true:
			DisplayServer.window_set_mode(3)
			buton.disabled = true
			butoff.disabled = false
		false:
			DisplayServer.window_set_mode(0)
			buton.disabled = false
			butoff.disabled = true

func window_confirm_button(): ##################################################
	##Размер окна
	var Screen_Size = Vector2(active_resolution[0], active_resolution[1])
	var Scale = Vector2(active_resolution[2],active_resolution[2])
	
	control_module.position = Vector2(active_resolution[3],active_resolution[4])
	control_module.scale = Scale
	
	DisplayServer.window_set_size(Screen_Size)
	get_viewport().size = Screen_Size

	print("Screen_Size: ",Screen_Size)
	print("Scale: ",Scale)
	print("control_module.position: ",control_module.position)

	config.BASE_RES_NUM = window_res_slider.value
	SaveScript.config_save(window_res_slider.value,buton.disabled)

func window_resolution_slider():
	var num = window_res_slider.value
	var result = config.resolution_list[int(num)]
	var text = str(result[0],"x",result[1])
	window_res_label.text = text
	active_resolution = result
	
func settings_brightness_slider():
	global.brightness = brightness_slider.value
	brightness_slider_lable.text = str(brightness_slider.value)
