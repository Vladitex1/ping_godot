extends Button
@onready var main_menu = $"../../main_menu"
@onready var settings_menu = $".."
@onready var special = $"../../special"

#var window_size = OS.get_real_window_size()

func _pressed():
<<<<<<< Updated upstream


	
=======
	settings_menu.hide()
	main_menu.show()
	special.show()
	print(window)
	var size2 = "5000"
	ProjectSettings.set("application/config/name",size2)
	print(ProjectSettings.get_setting_with_override("application/config/name"))
	#ProjectSettings.set_setting_with_override("application/config/name")
>>>>>>> Stashed changes

