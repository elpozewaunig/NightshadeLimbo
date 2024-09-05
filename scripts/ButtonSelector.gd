extends Node2D
class_name ButtonSelector

@export var buttons : Array[Area2DButton] = []

var highlight_active = false
var highlight_index = 0

signal set_key_mode(source)
signal ext_selected(button)
signal ext_cleared

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for button in buttons:
		# Connect all buttons to the external selection signals
		ext_selected.connect(button._on_ext_selected)
		ext_cleared.connect(button._on_ext_cleared)
		
		# Connect self to button's select signal
		button.selected.connect(_on_btn_selected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if buttons[highlight_index].is_visible_in_tree() and not buttons[highlight_index].disabled:
		if Input.is_action_just_pressed("ui_up"):
			activate_or_move("up")
		if Input.is_action_just_pressed("ui_down"):
			activate_or_move("down")

func activate_or_move(move: String) -> void:
	# If a button is currently highlighted
	if highlight_active or buttons[highlight_index].mouse_inside:
		if (move == "up" and highlight_index > 0):
			highlight_index -= 1
		elif (move == "down" and highlight_index < buttons.size() - 1):
			highlight_index += 1
	
	# Else, just enable the highlight but don't change the position
	emit_signal("set_key_mode", self)
	highlight_active = true
	emit_signal("ext_selected", buttons[highlight_index])
	
	# Notify buttons of the currently highlighted button
	emit_signal("ext_selected", buttons[highlight_index])

func _on_key_mode_changed(active, source) -> void:
	# Input through keyboard, signal came from another button selector
	if active and not source == self:
		highlight_active = true
		emit_signal("ext_selected", buttons[highlight_index])
		
	# Input through mouse
	else:
		highlight_active = false
		emit_signal("ext_cleared")

# When a button reports that it has been selected, update the selection index
func _on_btn_selected(button):
	if not highlight_active:
		for i in range(0, buttons.size()):
			if buttons[i] == button:
				highlight_index = i
