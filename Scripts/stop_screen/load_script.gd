extends ScrollContainer

###СКРИПТ НА СОХРАНЕНИЕ/Загрузку

var savelist

func _ready():
	savelist = SaveScript.show_save_dir()
	refresh()
			
func refresh(): ##выводит содержимое переопределяя ечейки
	var path = $".".get_child(0)
	for i in len(savelist):
		var slot = load("res://Scenes/stop_screen/save_slot.tscn").instantiate()
		path.add_child(slot)
		path.get_child(i).name = "save_" + str(savelist[i][1]) ###название слота
		var label1 = path.get_child(i).get_child(1)
		var label2 = path.get_child(i).get_child(2)
		label1.text = "save " + str(savelist[i][1])##заполение текста в label1
		label2.text = "pos " + str(savelist[i][0])##заполение текста в label2
