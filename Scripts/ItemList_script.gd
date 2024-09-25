extends Node
var first_open = true
var CurrentID: int = -1

var itemlist = {
	##ID#####COST##TEXTURE######################NAME####SELLCOST
	-1: [0, load("res://assets/items/loot/block_large.png"),"blocked",0],
	0: [0, load("res://assets/items/loot/none.png"), "null",0],
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
	0: [1,2,0,0,
		-1,-1,-1,-1,
		-1,-1,-1,-1,
		-1,-1,-1,-1],
	1: [2,1,0,0,
		0,0,0,0,
		-1,-1,-1,-1,
		-1,-1,-1,-1],
	2: [0,0,0,0,
		0,0,0,0,
		0,0,0,0,
		-1,-1,-1,-1],
	3: [0,0,0,0,
		0,0,0,0,
		0,0,0,0,
		0,0,0,0]}

var inventory: Array = [
		0,0,0,0,
		0,0,0,0,
		0,0,0,0,
		0,0,0,0]


var keybinds = {	
	0: ["UP", 87, "move_up"],
	1: ["DOWN", 83, "move_down"],
	2: ["LEFT", 65, "move_left"],
	3: ["RIGHT", 68, "move_right"],
	4: ["Sprint", 4194325, "special_shift"],
	5: ["drop item", 71, "special_drop"],
	6: ["BACK", 4194305, "special_back"],
	7: ["Spawn_Unite", 73, "debug2"],
	8: ["Console", 96,"special_console"],
	9: ["null", null, "null"], ##Костыль :)
	}


