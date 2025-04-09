extends Node2D

@onready var node = $"."
@onready var area = $Area2D
@onready var texture = $TextureRect
@export var item = loot_list.HEALTH
var pickup_block:bool = true
var pickup_wait: int = 0


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
	await get_tree().create_timer(1.0).timeout

func pickup(temp):
	##Прикрутить добавление в инвентарь	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	var pickup_block:bool = false
	for i in range(itemlist.inventory.size()):
		if itemlist.inventory[i][0] == temp:
			node.queue_free()
			global.get_global_scene("inventory").get_child(0).slot(i,temp,itemlist.inventory[i][1]+1)
			global.get_global_scene("inventory").get_child(0).inventory_save()
			pickup_block = true
			break
	if !pickup_block:
		for i in range(itemlist.inventory.size()):
			if itemlist.inventory[i][0] == 0:
				node.queue_free()
				global.get_global_scene("inventory").get_child(0).slot(i,temp,1)
				global.get_global_scene("inventory").get_child(0).inventory_save()
				break
			

func zone_entered(body):
	if body.name == "player":
		pickup_wait+=1
		if pickup_wait > 1:
			pickup(temp)
		
func zone_exited(body):
	if body.name == "player":
		pickup_block = false
