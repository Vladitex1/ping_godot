extends Area2D

var shop_ready = false
func shop_enter():
	global.del_scene("hud")
	global.add_scene("shop")
	global.del_scene("inventory")
	
func shop_exit():
	global.del_scene("shop")
	global.hud_load()
	

func _on_body_entered(body):
	if str(body.name) == "Player":
		print("вход в территорию магазина - shop_interface")
		global.set_tougle(3,true)
		shop_ready = true


func _on_body_exited(body):
	print("выход из территории магазина - shop_interface")
	if str(body.name) == "Player":
		global.set_tougle(3,false)
		shop_exit()
		shop_ready = false
		
func _physics_process(_delta):
	if Input.is_action_just_released("press_key_event_on") and shop_ready:# and Global.get_tougle(1) == true:
		shop_enter()
		global.set_tougle(3,false)




