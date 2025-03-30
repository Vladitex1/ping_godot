extends Node2D

@onready var node = $"."
@onready var area = $Area2D
@onready var texture = $TextureRect
@export var item = loot_list.HEALTH
var pickup_block:bool = true


enum loot_list {
NULL,
KEY,
COIN,
HEALTH,}
var temp:int
func _ready():
	area.connect("body_entered",zone_entered)
	area.connect("body_exited",zone_exited)
	var list = itemlist.itemlist 
	for i in list:
		if item == i:
			temp = i
			texture.texture = list[i]["TEXTURE"]
	pickup_block = true

func pickup(temp):
	##Прикрутить добавление в инвентарь	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	for i in range(itemlist.inventory.size()):
		if itemlist.inventory[i] == 0:
			node.queue_free()
			global.get_global_scene("inventory").get_child(0).slot(i,temp)
			global.get_global_scene("inventory").get_child(0).inventory_save()
			break
			

func zone_entered(body):
	if body.name == "player" and !pickup_block:
		pickup(temp)
		
func zone_exited(body):
	if body.name == "player" and pickup_block:
		pickup_block = false
