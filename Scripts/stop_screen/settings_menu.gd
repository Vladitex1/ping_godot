extends Control

var name2

func _ready():
	var back_settings_but = $settings_menu/settings/Button_Back
	back_settings_but.connect("button_up",back_button)
	var keymap_settings_but = $in_settings_buttons/button_list/keymap/Button_KeyMap
	keymap_settings_but.connect("button_down",keymap_button)
	var window_settings_but = $in_settings_buttons/button_list/window/Button_Window
	window_settings_but.connect("button_down",window_button)

func back_button():
	global.get_global_scene("stop_screen").select_menu("main")
	
func keymap_button():
	global.get_global_scene("stop_screen").select_menu("keybind")

func window_button():
	global.get_global_scene("stop_screen").select_menu("window")
