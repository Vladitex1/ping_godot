extends Node

var BASE_RES: Vector2 = Vector2(0,0)
var BASE_SCALE: Vector2 = Vector2(1,1)
var BASE_RES_NUM: int = 0
var TEMP_RES: int = 0

const resolution_list2:Dictionary = {
	####width,height,interface_scale
	1: [500,500,0.4,250,825],
	2: [1200,800,0.7,600,675],
	3: [1600,1000,0.88,775,1485],
	4: [1920,1080,1,960,1460],
	5: [2048,1080,1,250,825],
	6: [2940,1912,1.53,1475,1100]
}


const resolution_list:Dictionary = {
	####width,height,interface_scale
	1: [640,480,1.73,1630,1000],
	2: [1366,768,1.73,1780,1000],
	3: [1600,900,1.73,1750,1000],
	4: [1920,1080,1.73,1720,1000],
	5: [1920,1200,1.63,1600,1000],
	6: [2940,1912,1.63,1550,1000]
}
	

func _ready():
	BASE_RES = DisplayServer.screen_get_size(-1)
	print("найденный дисплей: ",BASE_RES)
	DisplayServer.window_set_size(BASE_RES)
	get_viewport().size = BASE_RES
	for i in resolution_list:
		if (BASE_RES[0] - resolution_list[i][0]) <= 50:
			print("предустановленное разрешение:",resolution_list[i][0],"x", resolution_list[i][1])
			BASE_RES_NUM = i
			TEMP_RES = i

'func window_reset_button():
	var scaled = 1.53
	var res = 4
	var base_resolution = Vector2(resolution_list[res][0],resolution_list[res][1])
	var positioned = Vector2(1475,1100)
	global.del_scene("hud")
	DisplayServer.window_set_size(base_resolution)
	get_viewport().size = base_resolution
	$CanvasLayer/control_module.scale = Vector2(scaled,scaled)
	$CanvasLayer/control_module.position = positioned
	get_tree().reload_current_scene()'
