extends Node

var grid = []
var combo = 0
var points = 0
var scores = [0, 0, 0, 0, 0]
var rng = RandomNumberGenerator.new()
var savePath = "user://scores.save"
var clearAnimScene = preload("res://scenes/clear_animation.tscn")

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
		while !validateAllPositions(group) and iter < 1000:
			group.queue_free()
			group = randomizeGroup().instantiate()
			iter+=1
		randomizeColor(group)
		p1.add_child(group)
		group = null
		iter = 0
		
		group = randomizeGroup().instantiate()
		while !validateAllPositions(group) and iter < 1000:
			group.queue_free()
			group = randomizeGroup().instantiate()
			iter+=1
		randomizeColor(group)
		p2.add_child(group)
		group = null
		iter = 0
		
		group = randomizeGroup().instantiate()
		while !validateAllPositions(group) and iter < 1000:
			group.queue_free()
			group = randomizeGroup().instantiate()
			iter+=1
		randomizeColor(group)
		p3.add_child(group)
		group = null
		iter = 0


func randomizeColor(group):
	var n = rng.randi_range(1,7)
	for c in group.get_children():
		c.get_child(0).texture = load("res://textures/blocks"+str(n)+".png")


func randomizeGroup():
	var n = 0
	var r = rng.randi_range(1, 100)
	if r <= 80:
		n = rng.randi_range(0,Easy.size()-1)
		return load("res://scenes/b_"+str(Easy[n])+".tscn")
	elif r <= 90:
		n = rng.randi_range(0,Medium.size()-1)
		return load("res://scenes/b_"+str(Medium[n])+".tscn")
	else:
		n = rng.randi_range(0,Hard.size()-1)
		return load("res://scenes/b_"+str(Hard[n])+".tscn")


func validateOnPosition(group, pos):	
	for c in group.get_children():
		var x = round((c.position.x+pos.x)/128)
		var y = round((c.position.y+pos.y)/128)
		if x > 7 or y > 7 or x < 0 or y < 0 or Globals.grid[x][y] != false:
			return false
	return true


func validateAllPositions(group):
	for i in range(8):
		for j in range(8):
			if validateOnPosition(group, Vector2(i*128,j*128)):
				return true
	return false


func checkForLines():
	var tmp = grid.duplicate(true)
	var countv
	var counth
	var comboUp = false
	
	for i in range(8):
		countv = 0
		counth = 0
		for j in range(8):
			if(tmp[i][j]==true): countv+=1
			if(tmp[j][i]==true): counth+=1
		if(countv==8):
			for j in range(8):
				grid[i][j] = false
			comboUp = true
			combo += 1
			points += 100 * combo
			spawnClearAnim(i*128, 0, 0)
			get_node("/root/Game/Jingle").pitch_scale = (combo-1)*0.1+1
			get_node("/root/Game/Jingle").play()
		if(counth==8):
			for j in range(8):
				grid[j][i] = false
			comboUp = true
			combo += 1
			points += 100 * combo
			spawnClearAnim(0, (i+1)*128, -PI/2)
			get_node("/root/Game/Jingle").pitch_scale = (combo-1)*0.1+1
			get_node("/root/Game/Jingle").play()
			
	if !comboUp: combo = 0
	
	if combo > 1:
		get_node("/root/Game/lbCombo").text = "[rainbow][wave amp=100 freq=10]COMBO X"+str(combo)
		get_node("/root/Game/lbCombo").opacity = 1
		comboPlay()
	
	#delete empty groups
	for c in get_node("/root/Game/Board").get_children():
		if c.get_child_count() == 0:
			c.queue_free()


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
	
	if count == 3: return true
	else: return false


func loadScores():
	if FileAccess.file_exists(savePath):
		var file = FileAccess.open(savePath,FileAccess.READ)
		scores = file.get_var()


func saveScore():
	var min = scores[0]
	
	for s in scores:
		if s < min: min = s
		
	if points > min:
		for i in range(scores.size()):
			if scores[i] == min: 
				scores[i] = points
				break
	
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	file.store_var(scores)
	file.close()
	

func spawnClearAnim(x, y, r):
	var instance = clearAnimScene.instantiate()
	instance.position = Vector2(x,y)
	instance.rotation = r
	get_node("/root/Game/Board").add_child(instance)
	

func comboPlay():
	if combo == 2:
		get_node("/root/Game/Combo").stream = load("res://sfx/good.wav")
	elif combo == 3:
		get_node("/root/Game/Combo").stream = load("res://sfx/great.wav")
	elif combo == 4:
		get_node("/root/Game/Combo").stream = load("res://sfx/amazing.wav")
	elif combo == 5:
		get_node("/root/Game/Combo").stream = load("res://sfx/excellent.wav")
	elif combo >= 6:
		get_node("/root/Game/Combo").stream = load("res://sfx/unbelievable.wav")
	else: return
	
	get_node("/root/Game/Combo").play()
