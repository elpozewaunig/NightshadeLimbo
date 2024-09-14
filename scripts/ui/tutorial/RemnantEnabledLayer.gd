extends Node2D

func _process(_delta: float) -> void:
	if Data.remnant_active:
		show()
	else:
		hide()
