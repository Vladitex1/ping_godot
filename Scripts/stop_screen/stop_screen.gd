extends Control

var size1 = 1
@onready var window = $"."
@onready var settings_menu = $CanvasLayer/settings_menu
@onready var main_menu = $CanvasLayer/main_menu
@onready var delay_timer = $CanvasLayer/DelayTimer

func _ready():
	delay_timer.start(0.2)
	#position = global.get_camera_position(1)
	#set_view_size()
	get_tree().paused = true
	show()
	
	
func debug():
	
	if Input.is_action_just_released("special_minus"):
		size1 = size1 - 0.01
	if Input.is_action_just_released("special_plus"):
		size1 = size1 + 0.01
	window.scale = Vector2(size1,size1)	
	print("размер камеры")
	print(global.get_camera_position(2)[0])

	#print(1.7-1.4)
	#print(2.3-1.7)
	#print(3.5-2.3)
	
	print("size1 - шаг вычитаемого = "+str(size1))
	
	print(scale)
	
func set_view_size():
	match global.get_camera_position(2)[0]:
		1.5:
			size1 = 1.34
		2.0:
			size1 = 1
		2.5:
			size1 = 0.8
	window.scale = Vector2(size1,size1)
	
	
func _process(delta):
	#debug()
	if delay_timer.is_stopped() == true:
		#print("Timer - off")
		if Input.is_action_just_released("special_back"):
			print("стоп - офф")
			get_tree().paused = false
			global.del_scene("stop_screen")



func _on_continue_button_up():
	get_tree().paused = false
	#get_tree().quit()
	global.del_scene("stop_screen")
func _on_settings_button_up():
	main_menu.hide()
	settings_menu.show()

	##методы сбора информации в консоль
	var window = OS.get
	print(window)
	var size2 = "5000"
	ProjectSettings.set("application/config/name",size2)
	print(ProjectSettings.get_setting_with_override("application/config/name"))
	#ProjectSettings.set_setting_with_override("application/config/name")
func _on_quit_button_up():
	get_tree().quit()

###settings menu
func _on_back_button_up():
	settings_menu.hide()
	main_menu.show()
