extends Control


# 2,5 - 1,25
# 2 - 1
# 1,5 - 0,75



func _ready():
	get_tree().paused = true
	position = global.get_camera_position(1)
	#var size2: Vector2 = Vector2(global.get_camera_position(2)[0]/2,global.get_camera_position(2)[1]/2)
	
	
func _process(delta):
	print(global.get_camera_position(2))
	var size2: Vector2 = Vector2(global.get_camera_position(2)[0]/2,global.get_camera_position(2)[1]/2)
	print(size2)
	scale =  Vector2(1,1)
	if Input.is_action_just_released("special_back"):
		print("стоп")
		get_tree().paused = false
		global.del_scene("stop_screen")
