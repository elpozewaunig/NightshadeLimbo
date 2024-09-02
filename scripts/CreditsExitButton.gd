extends Area2DButton


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	if Input.is_action_just_pressed("ui_cancel") and is_visible_in_tree():
		emit_signal("clicked")
		click_sfx.play()
