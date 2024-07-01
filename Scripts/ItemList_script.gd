extends Node

var CurrentID: int = -1

static var itemlist = {
	##ID#####COST##TEXTURE##############################NAME####
	0: [0, load("res://assets/special/none.png"), "null"],
	-1: [0, load("res://assets/interface/slot_block.png"),"blocked"],
	1: [2, load("res://assets/interface/Key1.png"),"key"],
	2: [2, load("res://assets/interface/coin.png"),"coin"],
	3: [5, load("res://assets/interface/continuebutton2.png"),"continue"],
	4: [10, load("res://assets/interface/interactive.png"),"interactive"]}

static var shop_storage = {
	0: [1,2,3,4,-1,-1,-1,-1],
	1: [2,2,2,2,-1,-1,-1,-1],
	2: [3,3,3,3,-1,-1,-1,-1],
	3: [4,4,4,4,-1,-1,-1,-1]}
	
static var inventory_storage = {
	0: [1,2,3,4,
		-1,-1,-1,-1,
		-1,-1,-1,-1,
		-1,-1,-1,-1],
	1: [1,2,3,4,
		0,0,0,0,
		-1,-1,-1,-1,
		-1,-1,-1,-1],
	2: [1,2,3,4,
		0,0,0,0,
		0,0,0,0,
		-1,-1,-1,-1],
	3: [1,2,3,4,
		0,0,0,0,
		0,0,0,0,
		0,0,0,0]}
