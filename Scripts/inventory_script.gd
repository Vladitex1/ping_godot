extends TextureRect

var open = true

var hiden_inventory_pos = Vector2(1156,1052)
var show_inventory_pos = Vector2(1116,630)
var step = 100

func inventory_tougle(open):
	if open == false:
		position_up()
	else:
		position_down()



func _ready():
	set_position(hiden_inventory_pos)
	open = true

func position_up():
	set_position(hiden_inventory_pos)
	open = true
func position_down():
	set_position(show_inventory_pos)
	open = false
	
func _process(delta):
	if Input.is_action_just_released("special_tab"):
		inventory_tougle(open)

