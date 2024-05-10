extends Camera2D


func zoom():
	var step = 0.5
	var min_zoom = 3
	var max_zoom = 1
	
	if Input.is_action_just_released('wheel_down'):
		set_zoom(get_zoom() - Vector2(step, step))
		if get_zoom() == Vector2(max_zoom,max_zoom):
			set_zoom(get_zoom() + Vector2(step, step))
			
	if Input.is_action_just_released('wheel_up'): #and get_zoom() > Vector2.ONE:
		set_zoom(get_zoom() + Vector2(step, step))
		if get_zoom() == Vector2(min_zoom,min_zoom):
			set_zoom(get_zoom() - Vector2(step, step))

func _physics_process(delta):
	zoom()


