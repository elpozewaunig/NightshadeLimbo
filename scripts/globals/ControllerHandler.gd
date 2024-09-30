extends Node

enum Type {KEYBOARD, TOUCH, PLAYSTATION, XBOX, NINTENDO, UNKNOWN}
var type : Type = Type.KEYBOARD
var last_type : Type

enum Category {KEYBOARD, TOUCH, JOYPAD}
var category : Category = Category.KEYBOARD
var last_category : Category

var category_matches : Dictionary = {
	Type.KEYBOARD: Category.KEYBOARD,
	
	Type.TOUCH: Category.TOUCH,
	
	Type.PLAYSTATION: Category.JOYPAD,
	Type.XBOX: Category.JOYPAD,
	Type.NINTENDO: Category.JOYPAD,
	Type.UNKNOWN: Category.JOYPAD
}

signal input_type_changed(type_index)
signal input_category_changed(category_index)

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
			type = Type.UNKNOWN
	
	category = category_matches[type]
	
	# Controller/input type has changed
	if type != last_type:
		input_type_changed.emit(type)
		last_type = type
	
	if category != last_category:
		input_category_changed.emit(category)
		last_category = category

func vibrate(weak_magnitude: float, strong_magnitude: float, duration: float = 1) -> void:
	if category == Category.JOYPAD:
		Input.start_joy_vibration(0, weak_magnitude, strong_magnitude, duration)
	elif category == Category.TOUCH:
		Input.vibrate_handheld(int(duration * 1000), clamp(strong_magnitude + weak_magnitude / 2, 0, 1))

func touch_haptic_feedback() -> void:
	if category == Category.TOUCH:
		Input.vibrate_handheld(20, 0.2)
