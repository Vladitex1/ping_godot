extends PanelContainer

var open = true

@onready var show_animation = $inventory_pos_animation

func inventory_tougle():
	if open:
		open = false
		show_animation.play("inventory_show_animation")
	else:
		open = true
		show_animation.play_backwards("inventory_show_animation")	

func _process(delta):
	if Input.is_action_just_released("special_tab"):
		inventory_tougle()

