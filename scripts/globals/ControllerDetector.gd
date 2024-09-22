extends Node

enum Type {KEYBOARD, TOUCH, PLAYSTATION, XBOX, NINTENDO}
var type : Type = Type.KEYBOARD
var last_type : Type

signal input_method_changed(type_index)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Always run detector in background, even when paused
	process_mode = PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	# Keyboard is used
	if event is InputEventKey:
		type = Type.KEYBOARD
	
	# Touchscreen is used
	elif event is InputEventScreenTouch:
		type = Type.TOUCH
	
	# When controller is used, detect controller type
	elif (event is InputEventJoypadButton) or (event is InputEventJoypadMotion):
		var controller_name : String = Input.get_joy_name(0)
		
		if controller_name.contains("PlayStation") or controller_name.contains("DUALSHOCK"):
			type = Type.PLAYSTATION
		elif controller_name.contains("Xbox"):
			type = Type.XBOX
		elif controller_name.contains("Switch"):
			type = Type.NINTENDO
		else:
			# Fallback to display keyboard in case of unknown controller
			type = Type.KEYBOARD
	
	# Controller/input type has changed
	if type != last_type:
		input_method_changed.emit(type)
		last_type = type
