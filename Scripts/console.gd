extends CanvasLayer

var teleport_toggle: bool = false
@onready var console_node = $"."
@onready var console_line = $LineEdit


func _process(delta):
	if Input.is_action_just_released("enter") and !global.buttons_lock:
		var command = str(console_line.get_text())
		var text = console_text_parse(command)
		console_line.set_text(text)
		await get_tree().create_timer(2).timeout
		console_line.set_text("")


func console_text_parse(text : String):
	text = text.lstrip(" ").rstrip(" ")
	var firstSpace : int = text.find(" ")
	var secondSpace : int = text.find(" ",firstSpace+1)
	var command : String
	var value1 : String
	var value2 : String
	if firstSpace == -1:
		command = text
	else:
		command = text.substr(0, firstSpace)
		value1 = text.substr(firstSpace+1,secondSpace - firstSpace-1)
		value2 = text.substr(secondSpace+1,len(text))
	var text2
	if value1 == null:
		text2 = "input_error"
		return text2
	return input(str(command),value1,value2)


func teleport(x,y):
	var vector = Vector2(int(x),int(y))
	var node = $"/root/main".get_child(1).get_child(0)
	node.player.set_global_position(vector)
	
func item(value,delta):
	delta = int(delta)
	value = str(value)
	global.player_indicators(value,delta,"set")

func input(command,value1,value2):
	var text 
	match command:
		"teleport":
			teleport(value1,value2)
			text = str("teleported to: ",value1," ",value2)
		"item":
			item(value1,value2)
			text = str("give item: ",value1," in count = ",value2)
		_:
			text = "input_error"
	return text
