extends Camera2D


class_name camera
static var step = 0.5
static var min_zoom = 3
static var max_zoom = 1


func zoom():
	if Input.is_action_just_released('wheel_down') or Input.is_action_just_released("special_minus"):
		set_zoom(get_zoom() - Vector2(step, step))
		if get_zoom() == Vector2(max_zoom,max_zoom):
			set_zoom(get_zoom() + Vector2(step, step))
			
	elif Input.is_action_just_released('wheel_up') or Input.is_action_just_released("special_plus"): #and get_zoom() > Vector2.ONE:
		set_zoom(get_zoom() + Vector2(step, step))
		if get_zoom() == Vector2(min_zoom,min_zoom):
			set_zoom(get_zoom() - Vector2(step, step))
			
	
func get_camera_target_position():
	global.set_camera_position(get_target_position(),get_zoom())

func _process(delta):
	zoom()
	
	get_camera_target_position()


