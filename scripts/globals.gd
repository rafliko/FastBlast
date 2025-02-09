extends Node

var grid = []
var points = 0
var rng = RandomNumberGenerator.new()
var colors = [Color(0.83,0.4,0.84), Color(0.92,0.72,0.22), Color(0.23,0.7,0.88), Color(0.8,0.22,0.22), Color(0.25,0.71,0.25)]

var Easy = [4,5,6,7,12,13,14,15]
var Medium = [8,9,10,11,18,19,20,21,24,25,26,27,28,29,30,31]
var Hard = [0,1,2,3,16,17,22,23]

func getNewBlocks():
	var p1 = get_node("/root/Game/p1")
	var p2 = get_node("/root/Game/p2")
	var p3 = get_node("/root/Game/p3")
	var group = null
	var iter = 0
	
	if p1.get_child_count() == 0 and p2.get_child_count() == 0 and p3.get_child_count() == 0:
		group = randomizeGroup().instantiate()
		while !validateAllPositions(group) and iter < 10000:
			group.queue_free()
			group = randomizeGroup().instantiate()
			iter+=1
		randomizeColor(group)
		p1.add_child(group)
		group = null
		iter = 0
		
		group = randomizeGroup().instantiate()
		while !validateAllPositions(group) and iter < 10000:
			group.queue_free()
			group = randomizeGroup().instantiate()
			iter+=1
		randomizeColor(group)
		p2.add_child(group)
		group = null
		iter = 0
		
		group = randomizeGroup().instantiate()
		while !validateAllPositions(group) and iter < 10000:
			group.queue_free()
			group = randomizeGroup().instantiate()
			iter+=1
		randomizeColor(group)
		p3.add_child(group)
		group = null
		iter = 0


func randomizeColor(group):
	var color = colors[rng.randi_range(0,colors.size()-1)]
	for c in group.get_children():
		c.get_child(0).modulate = color


func randomizeGroup():
	var n = 0
	var r = rng.randi_range(1, 100)
	if r <= 50:
		n = rng.randi_range(0,Easy.size()-1)
		return load("res://scenes/b_"+str(Easy[n])+".tscn")
	elif r <= 80:
		n = rng.randi_range(0,Medium.size()-1)
		return load("res://scenes/b_"+str(Medium[n])+".tscn")
	else:
		n = rng.randi_range(0,Hard.size()-1)
		return load("res://scenes/b_"+str(Hard[n])+".tscn")


func validateOnPosition(group, pos):	
	for c in group.get_children():
		var x = round((c.position.x+pos.x)/128)
		var y = round((c.position.y+pos.y)/128)
		print(str(x)+" "+str(y))
		if x > 7 or y > 7 or x < 0 or y < 0 or Globals.grid[x][y] != false:
			return false
	return true


func validateAllPositions(group):
	for i in range(8):
		for j in range(8):
			if validateOnPosition(group, Vector2(i*128,j*128)):
				return true
	return false


func checkGameOver():
	var p1 = get_node("/root/Game/p1")
	var p2 = get_node("/root/Game/p2")
	var p3 = get_node("/root/Game/p3")
	var count = 0
	
	if p1.get_child_count() == 0 || !validateAllPositions(p1.get_child(0)):
		count+=1
	if p2.get_child_count() == 0 || !validateAllPositions(p2.get_child(0)):
		count+=1
	if p3.get_child_count() == 0 || !validateAllPositions(p3.get_child(0)):
		count+=1
	
	print("COUNT: "+str(count))
	
	if count == 3: return true
	else: return false
