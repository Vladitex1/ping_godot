extends Area2D

var shop_ready = false


func _on_body_entered(body:CharacterBody2D):
	if str(body.name) == "Player":
		print("вход в территорию магазина")
		shop_ready = true
		global.set_tougle(3,true)


func _on_body_exited(body:CharacterBody2D):
	print("выход из территории магазина")
	if str(body.name) == "Player":
		shop_ready = false
		global.set_tougle(3,false)
		global.del_scene("shop")
		global.hud_load()
		
func _physics_process(delta):
	if Input.is_action_just_released("press_key_event_on") and shop_ready:# and Global.get_tougle(1) == true:
		global.del_scene("hud")
		global.add_scene("shop")
		global.add_scene("inventory")
		print("магаз вкл")




