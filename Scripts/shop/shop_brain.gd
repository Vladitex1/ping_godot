extends Control

@onready var cost_lable = $shop_plate/text/cost
@onready var name_lable = $shop_plate/text/name
@onready var count_lable = $shop_plate/text/count

var count:int = 0
var cost:int = 0
var countstr:String
var coststr:String
var name1: String

func _process(delta):
	count_lable.text = countstr
	name_lable.text = name1
func _ready():
	countstr = str(count)
	$shop_plate/buttons/minus_button.connect("button_up",minus_button)
	$shop_plate/buttons/buy_button.connect("button_up",buy_button)
	$shop_plate/buttons/plus_button.connect("button_up",plus_button)
	$shop_plate/buttons/sell_button.connect("button_up",sell_button)
	$shop_plate/buttons/exit_button.connect("button_up",exit_button)
	
	
	##shop inventory
	
	
func minus_button():
	
	countstr = str(count)
	if count <= 0:
		count = 0
	else:
		count = count - 1
	
func plus_button():
	count = count + 1
	countstr = str(count)
	
func buy_button():
	pass
func sell_button():
	pass
func exit_button():
	print("shop_exit - shop_brain")
	global.del_scene("shop")
	#global.del_scene("inventory")
	global.hud_load()
	global.set_tougle(3,true)
