extends Node2D

@export var buttons : Array[Area2DButton] = []
var highlight_active = false
var highlight_index = 0

signal ext_selected(button)
signal ext_cleared()

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
	if buttons[highlight_index].visible and is_visible_in_tree():
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
	highlight_active = true
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	emit_signal("ext_selected", buttons[highlight_index])

func _input(event):
	# After the mouse is moved, disable the highlight
	if event is InputEventMouseMotion:
		highlight_active = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		emit_signal("ext_cleared")

# When a button reports that it has been selected, update the selection index
func _on_btn_selected(button):
	if not highlight_active:
		for i in range(0, buttons.size()):
			if buttons[i] == button:
				highlight_index = i
