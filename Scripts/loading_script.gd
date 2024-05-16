extends Node2D

var ready_game_process = false

func _process(delta):
	if ready_game_process == false:
		ready_game_process = true
		print("работа")
		global.hud_load()
