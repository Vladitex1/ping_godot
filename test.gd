extends Sprite2D


@onready var nav_agent: NavigationAgent2D = get_node("NavigationAgent2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(Input.is_action_pressed("attack")):
		var targetPos = get_global_mouse_position()
		nav_agent.target_position = targetPos
		
		print(targetPos)
		print(nav_agent.is_target_reachable())
		
	var nextPoint = nav_agent.get_next_path_position()
	pass
