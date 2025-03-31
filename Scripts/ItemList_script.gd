extends Node
var first_open = true
var CurrentID: int = -1

var itemlist = {
	##ID#####COST##TEXTURE######################NAME####SELLCOST#######rare####discription
	-1: {"BUYCOST": 0,
		"SELLCOST":0,
		"NAME": "blocked",
		"DISCRIPTION": "block",
		"RARE": "standart",
		"TEXTURE": load("res://assets/items/loot/block_large.png"),
		},
	0: {"BUYCOST": 0,
		"SELLCOST":0,
		"NAME": "null",
		"DISCRIPTION": "null",
		"RARE": "standart",
		"TEXTURE": load("res://assets/special/none.png"),
		},
	1: {"BUYCOST": 2,
		"SELLCOST":1,
		"NAME": "health",
		"DISCRIPTION": "+15hp",
		"RARE": "standart",
		"TEXTURE": load("res://assets/items/loot/health_icon_large.png"),
		},
	2: {"BUYCOST": 2,
		"SELLCOST":1,
		"NAME": "coin",
		"DISCRIPTION": "piece of steel",
		"RARE": "standart",
		"TEXTURE": load("res://assets/items/loot/coin_icon_large.png"),
		},
	3: {"BUYCOST": 2,
		"SELLCOST":1,
		"NAME": "key",
		"DISCRIPTION": "key for door",
		"RARE": "standart",
		"TEXTURE": load("res://assets/items/loot/key_icon_large.png"),
		}}


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

#var inventory: Array = [
#		1,2,3,0,
#		0,0,0,0,
#		0,0,0,0,
#		0,0,0,0]

var inventory = {
	0: [1,1], 1: [2,3], 2:[3,6], 3:[0,1],
	4: [-1,1], 5: [-1,1], 6:[-1,1], 7:[-1,1],
	8: [-1,1], 9: [-1,1], 10:[-1,1], 11:[-1,1],
	12: [-1,1], 13: [-1,1], 14:[-1,1], 15:[-1,1],
}



var keybinds = {	
	0: ["UP", 87, "move_up"],
	1: ["DOWN", 83, "move_down"],
	2: ["LEFT", 65, "move_left"],
	3: ["RIGHT", 68, "move_right"],
	4: ["Sprint", 4194325, "special_shift"],
	5: ["drop item", 71, "special_drop"],
	6: ["BACK", 4194305, "special_back"],
	7: ["Spawn_Unite", 73, "debugI"],
	8: ["Console", 16777240,"special_console"],
	9: ["null", null, "null"], ##Костыль :)
	}
