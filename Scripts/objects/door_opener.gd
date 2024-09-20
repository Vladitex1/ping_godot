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
@onready var LS1texON = $DoorOpener1LsON
@onready var RS1texON = $DoorOpener1RsON
@onready var LS2texON = $DoorOpener2LsON
@onready var RS2texON = $DoorOpener2RsON

var current_tex
var status: bool = false

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
					current_tex = "LS1tex"
				side_state.RIGHT:
					RS1tex.visible = true
					current_tex = "RS1tex"
		2:
			match side:
				side_state.LEFT:
					LS2tex.visible = true
					current_tex = "LS2tex"
					
				side_state.RIGHT:
					RS2tex.visible = true
					current_tex = "RS2tex"
					
	
	
func _process(delta):
	var target_door = node.get_parent().get_parent().get_child(1).opener_list[door_num]
	print(target_door)
	print("*******")
	if opener_ready == true:
		if Input.is_action_just_released("special_use"):
			global.action_toggle = false
			
			if target_door[0][door_opener_num] == false:
				status = true
		
			buttons_texture(current_tex,!status)
				
			target_door[0][door_opener_num] = status
			
			print(target_door)

func buttons_texture(name,status):
	match name:
		"LS1tex":
			LS1tex.visible = status
			LS1texON.visible = !status
		"RS1tex":
			RS1tex.visible = status
			RS1texON.visible = !status
		"LS2tex":
			LS2tex.visible = status
			LS2texON.visible = !status
		"RS2tex":
			RS2tex.visible = status
			RS2texON.visible = !status
		

func body_entered(body):
	print(body.name)
	if body.name == "player" and !status:
		opener_ready = true
		global.action_toggle = true
		print("**********")
		
func body_exited(body):
	if body.name == "player":
		opener_ready = false
		global.action_toggle = false


