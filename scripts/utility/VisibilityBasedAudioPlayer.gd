extends AudioStreamPlayer

@onready var parent : CanvasItem = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if parent.is_visible_in_tree():
		if not playing:
			play()
	else:
		stop()
