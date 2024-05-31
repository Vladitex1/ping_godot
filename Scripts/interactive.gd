extends Sprite2D

@onready var loading_animation = $"../Waiting_Animation"

func _process(delta):
	
	
	if global.get_tougle(3) == true and global.get_tougle(2) != true:
		show()
	else:
		hide()
	
		
	if global.get_tougle(2) == true:
		loading_animation.play()
		loading_animation.show()
		
	else:
		loading_animation.hide()
		loading_animation.stop()
		

		
	
		
