extends Node

var teleport_tougle: bool = false

func teleport(x,y):
	var vector = Vector2(int(x),int(y))
	teleport_tougle = true
	global.set_player_pos(vector)
	
func item(value,delta):
	delta = int(delta)
	value = str(value)
	print(delta)
	match value:
		"key":
			global.PlayerIndicators("key",delta,"set")
		"coin":
			global.PlayerIndicators("coin",delta,"set")
		"hp":
			global.PlayerIndicators("hp",delta,"set")
		"stamina":
			global.PlayerIndicators("stamina",delta,"set")
	#print('|',value,'|',delta,'|',pminus,'|')

func input(command,value1,value2):
	match command:
		"teleport":
			teleport(value1,value2)
		"item":
			item(value1,value2)
		_:
			return "input error"
