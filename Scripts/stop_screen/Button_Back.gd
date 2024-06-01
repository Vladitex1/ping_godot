extends Button
@onready var main_menu = $"../../main_menu"
@onready var settings_menu = $".."
@onready var special = $"../../special"
func _pressed():
	settings_menu.hide()
	main_menu.show()
	special.show()
