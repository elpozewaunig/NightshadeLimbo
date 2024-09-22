extends Control
class_name PressableScreenArea


@onready var button_texture = $ButtonTexture

var enabled : bool = true

var is_pressed : bool = false
var is_just_pressed : bool = false

var reset_position : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_position = button_texture.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Only show when enabled and touch is used
	if enabled and ControllerDetector.type == ControllerDetector.Type.TOUCH:
		show()
	else:
		hide()
	
	if is_just_pressed:
		# Set is_just_pressed to false after this frame
		set_deferred("is_just_pressed", false)


func _unhandled_input(event: InputEvent):
	# Screen was just touched
	if event is InputEventScreenTouch and event.pressed and visible:
		if get_rect().has_point(event.position):
			is_pressed = true
			is_just_pressed = true
			button_texture.global_position = event.position
	
	# Screen was just released
	if event is InputEventScreenTouch and not event.pressed:
		is_pressed = false
		button_texture.position = reset_position
