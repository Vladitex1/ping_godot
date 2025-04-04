extends Node2D

@export var profile_name: String
var lvl_start_position: Vector2 = Vector2(263,279)
var start = false

func _ready():
	SaveScript.config_load()
func _process(delta) -> void:
	if !start:
		start = true
		global.buttons_lock = false
		
		global.add_scene("stop_screen/stop_screen")
		global.add_scene("hud")
		global.add_scene("inventory/inventory")
		global.add_scene("shop/shop")
		
		global.visible_scene("shop",false)
