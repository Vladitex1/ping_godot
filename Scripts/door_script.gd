extends Node

@onready var door_mask = $door_colisions/door_mask
@export var door_lvl: int
@export var door_num: int

"
пояснительная записка
если door_toggle == false -> Дверь не активна, закрыта
##уровень самой простой двери, открывается просто так, использует обычные ключи
##уровень удаленной двери, открывается от удаленного переключателя,ключи не требуются
##уровень двери при котором нужно 2 переключателя, ключи не требуются
"
@onready var opener_area: Node = $opener_area
@onready var node: Node = $"."
var door_toggle = false
var door_ready = false
var door_block = false
var IFT = false

func _ready():
	opener_area.connect("body_entered",body_entered)
	opener_area.connect("body_exited",body_exited)
	OpenerList.add_in_list(door_num,door_lvl)
	if door_lvl != 0:
		opener_area.monitoring = false
	
func _process(_delta):
	match door_lvl:
		0:
			if Input.is_action_just_released("special_use") and door_ready == true:
				door_lvl0()
		1:
			door_lvl1()
		2:
			door_lvl2()
	if door_ready == true:
		node.PROCESS_MODE_DISABLED
				
func door_lvl0():
	if door_toggle == false: ##Если дверь не активна, ее следует открыть
		door_toggle = true
	else:
		door_toggle = false ##Наоборот
		
	match door_toggle:
		false:##открытие/закрытие двери переключатель
			animation(door_toggle)
		true:
			if global.player_indicators("key", 0, "get") >= 1:
				global.player_indicators("key", -1, "set")
				animation(door_toggle)
			elif global.player_indicators("key", 0, "get") <= 0:
				pass
					
	await get_tree().create_timer(1).timeout 
	door_ready = false
	global.action_toggle = false
	
func door_lvl1():
	var opener_node = OpenerList.opener_list[door_num][0][1]
	if opener_node:
		animation(true)
		door_ready = false
	
func door_lvl2():
	var door_opener_1_status = OpenerList.opener_list[door_num][0][1] 
	var door_opener_2_status = OpenerList.opener_list[door_num][0][2]
	if door_opener_1_status and door_opener_2_status:
		animation(true)	
		door_ready = false
		
func animation(animation_bool):
	if animation_bool:
		door_mask.play("door_mask_open")
		await get_tree().create_timer(0.83).timeout
		door_mask.pause()
	else:
		door_mask.play_backwards("door_mask_open")
		await get_tree().create_timer(0.83).timeout
		door_mask.pause()
		if door_lvl == 1 or door_lvl == 2:
			opener_area.disabled = true
		
func body_entered(body):
	if str(body.name) == "player":
		door_ready = true
		global.action_toggle = true
		
func body_exited(body):
	if str(body.name) == "player":
		door_ready = false
		global.action_toggle = false
		
####
####await get_tree().create_timer(1).timeout 	
####
