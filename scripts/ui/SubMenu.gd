extends Node2D
class_name SubMenu

signal opened(submenu)

func _on_opened() -> void:
	opened.emit(self)
