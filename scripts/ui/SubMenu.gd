extends Node2D
class_name Submenu

signal opened(submenu)
signal closed

func _on_opened() -> void:
	opened.emit(self)

func _on_closed() -> void:
	closed.emit()
