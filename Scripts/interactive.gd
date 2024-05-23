extends Sprite2D

@onready var loading1 = $"../Loading1"
@onready var loading2 = $"../Loading2"
@onready var loading3 = $"../Loading3"
@onready var loading4 = $"../Loading4"

static var delay = 0.4

func _process(delta):
	if global.get_tougle(3) == true:
		show()
	else:
		hide()
	if global.get_tougle(2) == true:
		loading1.show()
		await get_tree().create_timer(delay).timeout
		loading1.hide()
		
		loading2.show()
		await get_tree().create_timer(delay).timeout
		loading2.hide()
		
		loading3.show()
		await get_tree().create_timer(delay).timeout
		loading3.hide()
		
		loading4.show()

