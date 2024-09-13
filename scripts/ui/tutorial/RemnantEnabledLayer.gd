extends Node2D

func _process(_delta: float) -> void:
	if Data.ghost_active:
		show()
	else:
		hide()
