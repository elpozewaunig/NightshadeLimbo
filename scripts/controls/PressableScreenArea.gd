extends Control
class_name PressableScreenArea

@onready var sprite : AnimatedSprite2D = $ButtonSprite

var enabled : bool = true

var is_pressed : bool = false
var is_just_pressed : bool = false

var reset_position : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	reset_position = sprite.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Only show when enabled and touch is used
	if enabled and ControllerHandler.category == ControllerHandler.Category.TOUCH:
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
			sprite.global_position = event.position
			sprite.frame = 1
			modulate.a = 0.5
	
	# Screen was just released
	if event is InputEventScreenTouch and not event.pressed:
		is_pressed = false
		sprite.position = reset_position
		sprite.frame = 0
		modulate.a = 1
