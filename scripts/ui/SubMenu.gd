extends Node2D
class_name Submenu

signal opened(submenu)

func _on_opened() -> void:
	opened.emit(self)
