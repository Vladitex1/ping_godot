extends Control

var size1 = 1
@onready var window = $"."
@onready var settings_menu = $CanvasLayer/settings_menu
@onready var main_menu = $CanvasLayer/main_menu
@onready var delay_timer = $CanvasLayer/DelayTimer
@onready var console_node = $CanvasLayer/console
@onready var console_line = $CanvasLayer/console/LineEdit
var console_visible = false
func _ready():
	delay_timer.start(0.2)
	#position = global.get_camera_position(1)
	#set_view_size()
	get_tree().paused = true
	show()

enum {
	GET,
	SET,
	KEYS,
	COINS,
	HP,
}	

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
			get_tree().paused = false
			global.del_scene("stop_screen")
		if Input.is_action_just_released("special_console"):
			console_tougle()
		if Input.is_action_just_released("enter") and console_visible == true:
			var command = str(console_line.get_text())
			parseInputText(command)
			print("input:",command," - stop_screen")


func parseInputText(text : String):
	text = text.lstrip(" ").rstrip(" ")
	var firstSpace : int = text.find(" ")
	var secondSpace : int = text.find(" ",firstSpace+1)
	var thirdSpace : int = text.find(" ",secondSpace+1)
	#print("Дебаг0: ",secondSpace)
	var command : String
	var value : String
	var value1 : String
	var value2 : String
	var value3 : String
	if firstSpace == -1:
		command = text
	else:
		command = text.substr(0, firstSpace)
		value1 = text.substr(firstSpace+1,secondSpace - firstSpace-1)
		value2 = text.substr(secondSpace+1,len(text))
		#value2 = text.substr(secondSpace+1,thirdSpace - secondSpace)
		#value3 = text.substr(thirdSpace+1,len(text))
		#print(command2[i])
	print("Дебаг1: ",value1 + "-")
	print("Дебаг2: ",value2)
	# Здесь можно добавить обработку команды teleport 500 500 или teleport 16 127
	#var split = command2.split(" ")
	#print((Vector2(split[1].to_int(), split[2].to_int())))
	console.input(str(command),value1,value2)#,value3)
 
'
			
func parseInputText(text : String):
	text = text.lstrip(" ").rstrip(" ")
	var firstSpace : int = text.find(" ")
	var secondSpace : int = text.substr(firstSpace,text.find(" "))
	var command : String
	var value : String
	var value1 : String
	var value2 : String
	
	if firstSpace == -1:
		command = text
	else:
		command = text.substr(0, firstSpace)
		value1 = text.substr(firstSpace+1,text.find(" "))
		print("1 : ",value[0])
		value2 = text.substr(value1+1,text.find(" "))
		#value.lstrip(" ")
		print(command)
		
		print("2 : ",value)
	print(command)'
	#console.input(str(command),value2[0],value2[1],value2[2])

	#console_tougle()
		
	#in_game_console.set_values(KEYS,10)
func console_tougle():
	if console_visible == true:	 
		console_node.visible = false
		console_visible = false
	else:
		console_visible = true
		console_node.visible = true

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
