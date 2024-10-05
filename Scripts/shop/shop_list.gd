extends Node2D

var shop_list: Dictionary = {}
var shop_num:int = 0

func add_in_list(shop_lvl:int):
	if !shop_list.has(shop_num):
		shop_list[str(shop_num)] = []
	shop_list[str(shop_num)] = shop_lvl
	print("new_shop_added: ",shop_num," lvl: ",shop_lvl)
	shop_num += 1
	return shop_num - 1
				
