extends RichTextLabel

var opacity = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if opacity > 0:
		modulate = Color(1,1,1,opacity)
		opacity -= delta*0.5
