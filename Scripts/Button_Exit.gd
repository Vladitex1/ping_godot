extends Button


func _pressed():
	get_tree().paused = false
	get_tree().quit()
	#global.del_scene("stop_screen")
