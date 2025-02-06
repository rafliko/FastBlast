extends Node2D

var dragging = false
var locked = false
var old_parent
var offset = Vector2(150,500)
var rng = RandomNumberGenerator.new()
var scene

# Called when the node enters the scene tree for the first time.
func _ready():
	randomizeColor()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dragging:
		get_node("..").position = (get_global_mouse_position()-offset)*1.6
	if locked:
		checkIfAlive()


func _on_button_button_down():
	if !locked:
		old_parent = get_node("../..")
		get_node("..").reparent(get_node("../../../Board"),false)
		dragging = true


func _unhandled_input(event):
	if event is InputEventMouseButton and dragging:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			checkAndLock()
			if !locked:
				get_node("..").reparent(old_parent,false)
				get_node("..").position = Vector2(0,0)
			dragging = false


func checkAndLock():
	get_node("..").position.x = round(get_node("..").position.x/128)*128
	get_node("..").position.y = round(get_node("..").position.y/128)*128
	var groupPosition = get_node("..").position
	for c in get_node("..").get_children():
		var x = round((c.position.x+groupPosition.x)/128)
		var y = round((c.position.y+groupPosition.y)/128)
		print(str(x)+" "+str(y))
		if x > 7 or y > 7 or x < 0 or y < 0 or Globals.grid[x][y] != false:
			return
	for c in get_node("..").get_children():
		var x = round((c.position.x+groupPosition.x)/128)
		var y = round((c.position.y+groupPosition.y)/128)
		Globals.grid[x][y] = true
		c.locked = true
		
	Globals.points += 10
	checkForLines()
	
	var p1 = get_node("/root/Game/p1")
	var p2 = get_node("/root/Game/p2")
	var p3 = get_node("/root/Game/p3")
	if p1.get_child_count() == 0 and p2.get_child_count() == 0 and p3.get_child_count() == 0:
		getNewBlocks()


func randomizeColor():
	var r = rng.randf_range(0,1)
	var g = rng.randf_range(0,1)
	var b = rng.randf_range(0,1)
	for c in get_node("..").get_children():
		c.get_child(0).modulate = Color(r,g,b)
		

func checkForLines():
	var countv
	var counth
	for i in range(8):
		countv = 0
		counth = 0
		for j in range(8):
			if(Globals.grid[i][j]==true): countv+=1
			if(Globals.grid[j][i]==true): counth+=1
		if(countv==8):
			for j in range(8):
				Globals.grid[i][j] = false
			Globals.points += 100
		if(counth==8):
			for j in range(8):
				Globals.grid[j][i] = false
			Globals.points += 100
				

func checkIfAlive():
	var groupPosition = get_node("..").position
	var x = round((position.x+groupPosition.x)/128)
	var y = round((position.y+groupPosition.y)/128)
	if(Globals.grid[x][y]==false): queue_free()
	
	
func getNewBlocks():
	var p1 = get_node("/root/Game/p1")
	var p2 = get_node("/root/Game/p2")
	var p3 = get_node("/root/Game/p3")
	scene = load("res://scenes/b_"+str(rng.randi_range(1,20))+".tscn")
	p1.add_child(scene.instantiate())
	scene = load("res://scenes/b_"+str(rng.randi_range(1,20))+".tscn")
	p2.add_child(scene.instantiate())
	scene = load("res://scenes/b_"+str(rng.randi_range(1,20))+".tscn")
	p3.add_child(scene.instantiate())
