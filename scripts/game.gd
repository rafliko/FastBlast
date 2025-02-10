extends Node2D

var rng = RandomNumberGenerator.new()
var scene

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.grid.clear()
	Globals.points = 0
	for i in range(8):
		Globals.grid.append([])
		for j in range(8):
			Globals.grid[i].append(false)
	Globals.getNewBlocks()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Points.text = str(Globals.points)


func _on_retry_pressed():
	get_tree().reload_current_scene()


func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
