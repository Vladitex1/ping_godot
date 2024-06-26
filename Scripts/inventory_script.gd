extends Control

class_name inventory

var open = true
@onready var show_animation = $inventory_pos_animation


func _ready():
	print("inventory_started - inventory_script")

func inventory_tougle():
	if open:
		open = false
		show_animation.play("inventory_show_animation")
	else:
		open = true
		show_animation.play_backwards("inventory_show_animation")	

func _process(_delta):
	if Input.is_action_just_released("special_tab"):
		inventory_tougle()
		print("inventory work - inventory_script")

################################################

