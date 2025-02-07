extends Node

var grid = []
var points = 0
var rng = RandomNumberGenerator.new()
var scene

func getNewBlocks():
	var p1 = get_node("/root/Game/p1")
	var p2 = get_node("/root/Game/p2")
	var p3 = get_node("/root/Game/p3")
	if p1.get_child_count() == 0 and p2.get_child_count() == 0 and p3.get_child_count() == 0:
		scene = load("res://scenes/b_"+str(rng.randi_range(1,23))+".tscn")
		p1.add_child(scene.instantiate())
		scene = load("res://scenes/b_"+str(rng.randi_range(1,23))+".tscn")
		p2.add_child(scene.instantiate())
		scene = load("res://scenes/b_"+str(rng.randi_range(1,23))+".tscn")
		p3.add_child(scene.instantiate())
