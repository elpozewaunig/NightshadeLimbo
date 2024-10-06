@tool
extends Node2D
class_name Submenu

@export_group("Editor Preview")
@export var ui_scalers : Array[UIScaler] = []
@export var preview_mobile : bool = false
var prev_preview_setting : bool = false

signal opened(submenu)
signal closed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if prev_preview_setting != preview_mobile:
			prev_preview_setting = preview_mobile
			for ui_scaler in ui_scalers:
				ui_scaler.preview_mobile = preview_mobile


func _on_opened() -> void:
	opened.emit(self)

func _on_closed() -> void:
	closed.emit()
