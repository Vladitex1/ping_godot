extends Node2D

@onready var node: Node = $"."
@export var list_num: int

func _ready():
	node.get_parent().add_in_list(list_num,global_position)
