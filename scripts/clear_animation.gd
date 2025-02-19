extends Node2D

var colors = ["blue", "cyan", "green", "orange", "purple", "red", "yellow"]
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.animation = colors[rng.randi_range(0,colors.size()-1)]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !$AnimatedSprite2D.is_playing(): queue_free()
