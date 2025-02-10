extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.loadScores()
	Globals.scores.sort_custom(func(a,b): return a > b)
	for i in range(Globals.scores.size()):
		$ScoreList.add_item(str(i+1)+". "+str(Globals.scores[i]))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
