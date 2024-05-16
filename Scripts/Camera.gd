extends Camera2D

static var step = 0.5
static var min_zoom = 3
static var max_zoom = 1

func zoom():
	
	if Input.is_action_just_released('wheel_down'):
		set_zoom(get_zoom() - Vector2(step, step))
		if get_zoom() == Vector2(max_zoom,max_zoom):
			set_zoom(get_zoom() + Vector2(step, step))
			
	if Input.is_action_just_released('wheel_up'): #and get_zoom() > Vector2.ONE:
		set_zoom(get_zoom() + Vector2(step, step))
		if get_zoom() == Vector2(min_zoom,min_zoom):
			set_zoom(get_zoom() - Vector2(step, step))

func _process(delta):
	zoom()


