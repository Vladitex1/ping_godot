extends Node
var first_open = true
var CurrentID: int = -1

var itemlist = {
	##ID#####COST##TEXTURE######################NAME####SELLCOST
	0: [0, load("res://assets/items/loot/null_large.png"), "null",0],
	-1: [0, load("res://assets/items/loot/block_large.png"),"blocked",0],
	1: [2, load("res://assets/items/loot/key_icon_large.png"),"key",1],
	2: [1, load("res://assets/items/loot/coin_icon_large.png"),"coin",1],
	3: [1, load("res://assets/items/loot/health_icon_large.png"),"health",1],
	4: [10, load("res://assets/interface/interactive.png"),"interactive",1]}

var shop_storage = {
	0: [1,2,3,2,-1,-1,-1,-1],
	1: [2,2,1,3,-1,-1,-1,-1],
	2: [1,3,1,2,-1,-1,-1,-1],
	3: [2,1,3,1,-1,-1,-1,-1]}
	
var inventory_storage = {
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

var keybinds = {	
	0: ["up", 87, "move_up"],
	1: ["down", 83, "move_down"],
	2: ["left", 65, "move_left"],
	3: ["right", 68, "move_right"],
	4: ["spawn_unite", 73, "debug2"],
	5: ["console", 96,"special_console"],
	6: ["sprint", 4194325, "special_shift"],
	7: ["menu", 4194305, "special_back"],
	8: ["null", null, "null"], ##Костыль :)
	}

