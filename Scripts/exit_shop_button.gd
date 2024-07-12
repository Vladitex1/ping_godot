extends Button

func _pressed():
	print("shop_exit")
	global.del_scene("shop")
	#global.del_scene("inventory")
	global.hud_load()
	global.action_tougle = true
