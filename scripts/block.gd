extends Node2D

var dragging = false
var locked = false
var old_parent
var offset = Vector2(200,700)
var rng = RandomNumberGenerator.new()
var gridX = 0
var gridY = 0
var basePos = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	basePos = get_node("..").position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dragging:
		get_node("..").position = (get_global_mouse_position()-offset)*2
	if locked:
		if !checkIfAlive():
			scale -= Vector2(1, 1) * delta * 3
			position += Vector2(1, 1) * delta * 200
			if scale <= Vector2(0.1, 0.1):
				queue_free()


func _on_button_button_down():
	if !locked:
		old_parent = get_node("../..")
		get_node("..").reparent(get_node("../../../Board"),false)
		get_node("..").z_index = 1
		dragging = true


func _unhandled_input(event):
	if event is InputEventMouseButton and dragging:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			validateAndLock()
			if !locked:
				get_node("..").reparent(old_parent,false)
				get_node("..").position = basePos
			get_node("..").z_index = 0
			dragging = false
			if Globals.checkGameOver() and !get_node("/root/Game/GameOver").visible:
				print("GAME OVER")
				get_node("/root/Game/GameOver").visible = true
				Globals.saveScore()


func validateAndLock():
	get_node("..").position.x = round(get_node("..").position.x/128)*128
	get_node("..").position.y = round(get_node("..").position.y/128)*128
	var groupPosition = get_node("..").position
	if Globals.validateOnPosition(get_node(".."), groupPosition):		
		for c in get_node("..").get_children():
			c.gridX = round((c.position.x+groupPosition.x)/128)
			c.gridY = round((c.position.y+groupPosition.y)/128)
			Globals.grid[c.gridX][c.gridY] = true
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
	return Globals.grid[gridX][gridY]
