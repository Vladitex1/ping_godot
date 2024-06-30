extends Node2D

var CurrentID: int = -1

static var itemlist = {
	"null": [0, load("res://assets/special/none.png"), "null"],
	"blocked": [0, load("res://assets/interface/slot_block.png"),"blocked"],
	"key": [2, load("res://assets/interface/Key1.png"),"Key"],
	"coin": [2, load("res://assets/interface/coin.png"),"Coin"],
	"example_1": [5, load("res://assets/interface/continuebutton2.png"),"Continue"],
	"example_2": [10, load("res://assets/interface/interactive.png"),"interactive"]}

var selecteditem


func select(num):
	match num:
		-1: 
			selecteditem = itemlist.itemlist["blocked"][1]
		1:
			selecteditem = itemlist.itemlist["null"][1]
		2:
			selecteditem  = itemlist.itemlist["example_1"][1]
		3:
			selecteditem  = itemlist.itemlist["example_2"][1]
		4:
			selecteditem = itemlist.itemlist["coin"][1]
		_:
			pass
