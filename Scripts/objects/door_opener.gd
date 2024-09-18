extends StaticBody2D
@export var door_num:int
@export var door_opener_num:int
@export var opener_lvl_tx:int 
@onready var opener_area = $Area2D
@onready var node = $"."

###textures

@onready var LS1tex = $DoorOpener1Ls
@onready var RS1tex = $DoorOpener1Rs
@onready var LS2tex = $DoorOpener2Ls
@onready var RS2tex = $DoorOpener2Rs
@export var side = side_state.RIGHT

enum side_state {
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

var opener_ready: bool = false

func _ready():
	opener_area.connect("body_entered",body_entered)
	opener_area.connect("body_exited",body_exited)
	LS1tex.visible = false
	match opener_lvl_tx:
		0:
			pass
		1:
			match side:
				side_state.LEFT:
					LS1tex.visible = true
				side_state.RIGHT:
					RS1tex.visible = true
		2:
			match side:
				side_state.LEFT:
					LS2tex.visible = true
				side_state.RIGHT:
					RS2tex.visible = true
	
	
func _process(delta):
	if opener_ready == true:
		if Input.is_action_just_released("special_use"):
			var status: bool = false
			var target_door = node.get_parent().get_parent().get_child(1).opener_list[door_num]
			if target_door[0][door_opener_num] == true:
				status = false
			else:
				status = true
			target_door[0][door_opener_num] = status
			print(target_door)

func body_entered(body):
	print(body.name)
	if body.name == "player":
		opener_ready = true
		global.action_toggle = true
		print("**********")
		
func body_exited(body):
	if body.name == "player":
		opener_ready = false
		global.action_toggle = false
