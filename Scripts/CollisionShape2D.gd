extends CharacterBody2D

var speed = 4
var delta = 1
var sprint = 2

	
func get_input():
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if Input.is_action_pressed("move_shift"):
		sprint	= 2
	else:
		sprint = 0
		
	velocity = input_dir * (speed + sprint)


func _physics_process(delta):
	get_input()
	move_and_collide(velocity)
