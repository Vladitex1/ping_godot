extends MarginContainer

var answer: bool
var function: Object

func _ready():
	var button_yes: Object = $VBoxContainer/HBoxContainer/YES
	var button_no: Object  = $VBoxContainer/HBoxContainer/NO
	button_yes.connect("button_down",Callable(self, "set_result").bind(true))
	button_no.connect("button_down",Callable(self, "set_result").bind(false))
	
func set_result(result:bool):
	visible = false
