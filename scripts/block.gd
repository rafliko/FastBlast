extends Node2D

var dragging = false
var locked = false
var old_parent
var offset = Vector2(150,500)
var rng = RandomNumberGenerator.new()
var scene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


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
			validateAndLock()
			if !locked:
				get_node("..").reparent(old_parent,false)
				get_node("..").position = Vector2(0,0)
			dragging = false
			if Globals.checkGameOver():
				print("GAME OVER")
				get_node("/root/Game/GameOver").visible = true


func validateAndLock():
	get_node("..").position.x = round(get_node("..").position.x/128)*128
	get_node("..").position.y = round(get_node("..").position.y/128)*128
	var groupPosition = get_node("..").position
	if Globals.validateOnPosition(get_node(".."), groupPosition):		
		for c in get_node("..").get_children():
			var x = round((c.position.x+groupPosition.x)/128)
			var y = round((c.position.y+groupPosition.y)/128)
			Globals.grid[x][y] = true
			c.locked = true
			
		Globals.points += 10
		checkForLines()
		Globals.getNewBlocks()


func checkForLines():
	var tmp = Globals.grid.duplicate(true)
	var countv
	var counth
	for i in range(8):
		countv = 0
		counth = 0
		for j in range(8):
			if(tmp[i][j]==true): countv+=1
			if(tmp[j][i]==true): counth+=1
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
	if(Globals.grid[x][y]==false): 
		queue_free()	
