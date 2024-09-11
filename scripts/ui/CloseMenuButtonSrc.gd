extends Area2DButtonSrc


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	if Input.is_action_just_pressed("ui_cancel") and is_visible_in_tree():
		clicked.emit()
		click_sfx.play()
