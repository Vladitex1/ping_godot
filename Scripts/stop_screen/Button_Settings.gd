extends Button

@onready var settings_menu = $"../../settings_menu"
@onready var main_menu = $".."
@onready var special = $"../../special"
func _pressed():
	special.hide()
	main_menu.hide()
	settings_menu.show()

	
	
	#global.del_scene("stop_screen")
