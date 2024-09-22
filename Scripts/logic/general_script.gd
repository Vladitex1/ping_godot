extends Node2D

@export var active_save: int 


func _ready():
	SaveScript.config_load()
	
