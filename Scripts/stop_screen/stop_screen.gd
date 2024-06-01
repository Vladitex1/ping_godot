extends Control

var size1 = 1
var size2 = 1

func _ready():
	set_view_size()
	get_tree().paused = true
	position = global.get_camera_position(1)
	
	
func debug():
	
	if Input.is_action_just_released("special_minus"):
		size1 = size1 - 0.1
	if Input.is_action_just_released("special_plus"):
		size1 = size1 + 0.1
		
	print("размер камеры")
	print(global.get_camera_position(2)[0])

	#print(1.7-1.4)
	#print(2.3-1.7)
	#print(3.5-2.3)
	
	print("size1 - шаг вычитаемого = "+str(size1))
	print("size2 - шаг вычитаемого = "+str(size2))
	
	print(scale)
	
func set_view_size():
	match global.get_camera_position(2)[0]:
		1.5:
			size1 = 2.3
		2.0:
			size1 = 1.7
		2.5:
			size1 = 1.4
			
func _process(delta):
	
	#debug()
	set_view_size()
	
	scale = Vector2(size1,size1)	
	
	if Input.is_action_just_released("special_back"):
		print("стоп")
		get_tree().paused = false
		global.del_scene("stop_screen")



