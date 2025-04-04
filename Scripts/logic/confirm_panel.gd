extends MarginContainer

@onready var button_yes: Object = $VBoxContainer/HBoxContainer/YES
@onready var button_no: Object  = $VBoxContainer/HBoxContainer/NO
@onready var question_label: Object = $VBoxContainer/Label
@onready var bar: Object = $Control/bar
@onready var timer: Object = $Control/Timer

var function: Object
var answer: bool = false
var result: bool = false
var time: int = 3

func _process(delta: float) -> void:
	bar.value = timer.time_left

func _ready():
	bar.max_value = 3 
	button_yes.connect("button_down",func(): result = true)
	button_yes.connect("pressed",func(): visible = false)
	button_no.connect("button_down",func(): result = false)
	button_no.connect("pressed",func(): visible = false)
	
func confirm_show(text:String):
	question_label.text = text
	visible = true
	timer.start(time)
	await timer.timeout
	visible = false
	return result
	
