extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.loadScores()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_scores_button_pressed():
	get_tree().change_scene_to_file("res://scenes/scores.tscn")


func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
