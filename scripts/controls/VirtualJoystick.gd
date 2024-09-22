extends Control
class_name VirtualJoystick

@onready var joystick = $Joystick
@onready var outline = $Joystick/Outline
@onready var stick = $Joystick/Stick

@export var max_stick_movement : float = 80
@export var deadzone : float = 0.25

var enabled : bool = true

var reset_position : Vector2 

var drag_active : bool = false
var input : Vector2 = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_position = joystick.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Only show when enabled and touch is used
	if enabled and ControllerDetector.type == ControllerDetector.Type.TOUCH:
		show()
	else:
		hide()
		input = Vector2(0, 0)
	
	if input.length() > max_stick_movement:
		# Cut off stick position at max_stick_movement using normalization
		stick.position = input.normalized()  * max_stick_movement
	else:
		stick.position = input


func _unhandled_input(event: InputEvent):
	# Screen was just touched
	if event is InputEventScreenTouch and event.pressed and visible:
		if get_rect().has_point(event.position - global_position):
			drag_active = true
			joystick.global_position = event.position
	
	# Screen was just released
	if event is InputEventScreenTouch and not event.pressed:
		drag_active = false
		input = Vector2(0, 0)
		joystick.position = reset_position
	
	# Screen is currently being dragged
	if event is InputEventScreenDrag and drag_active and visible:
		input = event.position - joystick.global_position
		
		# Ignore input if it doesn't exceed the deadzone
		if input.length() < max_stick_movement * deadzone:
			input = Vector2(0, 0)
