extends Node2D

# Synchronizes whether keyboard or mouse highlighting is used across button selectors
@export var selectors_to_sync : Array[ButtonSelector] = []

signal key_mode_changed(status, source)

# Called when the node enters the scene tree for the first time.
func _ready():
	for selector in selectors_to_sync:
		# Connect selectors to the key mode change signal
		key_mode_changed.connect(selector._on_key_mode_changed)
		
		# Connect self to selector highlight signal
		selector.set_key_mode.connect(set_key_mode)


func _input(event):
	# As soon as the mouse is moved, disable the highlight
	if event is InputEventMouseMotion:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		emit_signal("key_mode_changed", false, self)

func set_key_mode(source):
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	emit_signal("key_mode_changed", true, source)
