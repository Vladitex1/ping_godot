extends StaticBody2D

@onready var lamp_detect = $Area2D
@onready var lamp_col = $colision
var lamp_pickup = false
var ready_update_pos = false

func _ready():

	lamp_detect.connect("body_entered",body_entered)
	lamp_detect.connect("body_exited",body_exited)

func _process(delta):
	update_pos(ready_update_pos) ## обновление позиции предмета
	if Input.is_action_just_released("special_use") and lamp_pickup and !global.hold_in_hands:
		##подбор предмета
		pickup()
		ready_update_pos = true
		global.hold_in_hands = true
	if Input.is_action_just_released("special_drop") and lamp_pickup:
		##выбрасывание предмета
		drop()
		ready_update_pos = false
		global.hold_in_hands = false

func update_pos(ready: bool):
	if ready:
		position = global.get_player_pos() + Vector2(10,5)

func drop():
	position = global.get_player_pos() + Vector2(30,0)
	lamp_col.disabled = false
	z_index = 0
	global.pickup_toggle = false

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

