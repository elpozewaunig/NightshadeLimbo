extends Node2D
class_name SelectableButton

@onready var select_sfx : AudioStreamPlayer = $SelectSFX

var mouse_inside = false
var disabled = false
var highlight_active = false
var ext_selected = false

signal selected(selectable)
signal clicked

func _on_mouse_entered() -> void:
	if is_visible_in_tree() and not disabled:
		mouse_inside = true
		
		# Don't perform selection action if external selection is active
		if not highlight_active:
			_on_selected()

func _on_mouse_exited() -> void:
	mouse_inside = false

func _on_selected() -> void:
	selected.emit(self)
	select_sfx.play()

# Triggered by button selector through key/gamepad input
func _on_ext_selected(selectable_node) -> void:
	if not disabled:
		if selectable_node == self:
			# Only perform selection action when visible and not already selected
			if is_visible_in_tree() and not is_selected():
				_on_selected()
		
			highlight_active = true
			ext_selected = true
		
		else:
			highlight_active = true
			ext_selected = false

# Triggered by button selector when the current selection is replaced by mouse movement
func _on_ext_cleared() -> void:
	if highlight_active and mouse_inside and not disabled:
		_on_selected()
	highlight_active = false
	ext_selected = false

func _on_clicked() -> void:
	clicked.emit()

func _on_disabled() -> void:
	disabled = true


func is_selected() -> bool:
	return (ext_selected and highlight_active) or (mouse_inside and not highlight_active)
