extends Node2D

@onready var node = $"."
@onready var area = $Area2D
@onready var texture = $TextureRect
@export var item = loot_list.HEALTH

enum loot_list {
NULL,
KEY,
COIN,
HEALTH,}
var temp:int
func _ready():
	area.connect("body_entered",body)
	var list = itemlist.itemlist 
	for i in list:
		if item == i:
			temp = i
			texture.texture = list[i]["TEXTURE"]

func pickup(temp):
	
	match temp:
		loot_list.COIN:
			global.player_indicators("coin", 1, "set")
		loot_list.KEY:
			global.player_indicators("key", 1, "set")
		loot_list.HEALTH:
			global.player_indicators("hp", 15, "set")
			
	
	node.queue_free()

func body(body):
	if body.name == "player":
		pickup(temp)
