extends Node

var teleport_toggle: bool = false

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
		"hello":
			text = str(OS.get_name())
			if OS.get_name() == "macOS":
				text = str("Hello ", OS.get_environment("USER"),"!")
			else: 
				text = str("Hello ", OS.get_environment("USERNAME"),"!")
		"teleport":
			teleport(value1,value2)
			text = str("teleported to: ",value1," ",value2)
		"item":
			item(value1,value2)
			text = str("give item: ",value1," in count = ",value2)
		_:
			text = "input_error"
	return text
