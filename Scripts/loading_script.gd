extends Node2D

var ready_game_process = false

func _process(_delta):
	if ready_game_process == false:
		ready_game_process = true
		print("Включение игры - loading_script")
		global.hud_load()
		

