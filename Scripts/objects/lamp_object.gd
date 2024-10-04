extends StaticBody2D

@onready var lamp_detect = $Area2D
@onready var lamp_col = $colision
@onready var drop_tex = $lamp_drop_texture

var lamp_pickup = false
var ready_update_pos = false
var currect_position:bool = false
var drop_place = false

func _ready():
	lamp_detect.connect("body_entered",body_entered)
	lamp_detect.connect("body_exited",body_exited)

func _process(delta):
	update_pos(ready_update_pos,drop_place) ## обновление позиции предмета
	if Input.is_action_just_released("special_use") and lamp_pickup and !global.hold_in_hands:
		##подбор предмета
		pickup()
		ready_update_pos = true
		global.hold_in_hands = true
	if Input.is_action_just_released("special_drop") and lamp_pickup and !drop_place:
		##выбрасывание предмета - включение метки
		drop_place = true
	elif Input.is_action_just_released("attack") and lamp_pickup and currect_position and drop_place:
		drop()
	elif Input.is_action_just_released("scope"):
		drop_place = false
		drop_tex.visible = false

func update_pos(update_position: bool,drop_place: bool):
	var radius = 55
	var pos = get_global_mouse_position() - global.get_player_pos()
	if update_position:
		position = global.get_player_pos() + Vector2(5,5)
		drop_tex.position = get_local_mouse_position()
		
	if drop_place == true: ##если функция выбора позиции включено
		drop_tex.visible = true
		if (pos[0] > radius or pos[0] < radius * -1) or (pos[1] > radius or pos[1] < radius * -1):
			drop_tex.modulate = Color(1,0,0,1)
			currect_position = false
		else:
			drop_tex.modulate = Color(1,1,1,0.5)
			currect_position = true

func drop():
	position = get_global_mouse_position()
	lamp_col.disabled = false
	z_index = 0
	global.pickup_toggle = false
	ready_update_pos = false
	global.hold_in_hands = false
	drop_place = false
	drop_tex.visible = false

func pickup():
	lamp_col.disabled = true
	z_index = 2
	global.pickup_toggle = false

func body_entered(body):
	if body.name == "player" and !global.hold_in_hands:
		global.pickup_toggle = true
		lamp_pickup = true
		
func body_exited(body):
	if body.name == "player":
		global.pickup_toggle = false
		lamp_pickup = false
		ready_update_pos = false
