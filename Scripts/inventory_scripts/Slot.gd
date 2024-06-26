extends Panel

var is_drag = false
var mouse_entered2 = false
@onready var KofiArea = get_node("CanvasLayer/Control/GridContainer/Slot1/Slot_area")


func _ready():
	print("ready")
	KofiArea.connect.mouse_entered("_Kofi_Enter")

func _Kofi_Enter():
	print("ENTER")
	
