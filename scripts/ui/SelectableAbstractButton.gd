extends Node2D
class_name SelectableButton

@onready var select_sfx : AudioStreamPlayer = $SelectSFX

@export var selected_color: Color = Color("ff7070")
@export var default_color: Color = Color("ffffff")

var mouse_inside = false
var disabled = false
var highlight_active = false
var ext_selected = false

signal selected(selectable)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# If the button is selected (either through the mouse or key input)
	if (is_visible_in_tree() and is_selected() and not disabled
	# Don't perform selection if the mouse cursor is only "left over" after touch input
	and (ControllerHandler.category != ControllerHandler.Category.TOUCH or Input.is_action_pressed("ui_click"))):
		selection_behavior(delta)
	else:
		default_behavior(delta)

func _on_mouse_entered() -> void:
	if is_visible_in_tree() and not disabled:
		mouse_inside = true
		
		# Don't perform selection action if external selection is active
		if (not highlight_active
		# Don't perform selection if the mouse cursor is only "left over" after touch input
		and (ControllerHandler.category != ControllerHandler.Category.TOUCH or Input.is_action_pressed("ui_click"))):
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

func _on_disabled() -> void:
	disabled = true

# Triggered every frame when the button is selected
func selection_behavior(_delta: float) -> void:
	# To be implemented by inheriting classes
	pass

# Triggered every frame when the button is not selected
func default_behavior(_delta: float) -> void:
	# To be implemented by inheriting classes
	pass

func is_selected() -> bool:
	return is_ext_highlighted() or is_mouse_selected() or (is_being_used() and not highlight_active)

func is_ext_highlighted() -> bool:
	return ext_selected and highlight_active

func is_mouse_selected() -> bool:
	return mouse_inside and not highlight_active

func is_being_used() -> bool:
	# Should be overridden by UI elements that keep their active state during mouse movement
	return false
