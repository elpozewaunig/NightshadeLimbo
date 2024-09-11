extends Node2D

func _on_start_button_clicked() -> void:
	for child in get_children():
		if child.get_class() == "Area2D":
			child.disabled = true
