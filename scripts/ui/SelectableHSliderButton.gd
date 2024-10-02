extends SelectableButton
class_name SelectableHSliderButton

signal value_changed(value)

@export var acoustic_feedback : bool = true

@onready var slider : HSlider = $SliderButtonSrc
@onready var slider_sfx : AudioStreamPlayer = $SliderSFX
@onready var box : Sprite2D = $Box
@onready var grabber = $White2

var slider_speed : float = 30
var time_held : float = 0
var currently_used : bool = false

func selection_behavior(delta: float) -> void:
	box.modulate = Color(selected_color)
	grabber.visible = true
	
	var input = Input.get_axis("ui_left", "ui_right")
	var just_pressed = Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right")
	if input:
		# Require keeping the action pressed for some time before making a fixed-step adjustment
		time_held += delta
		if just_pressed or time_held > 1 / slider_speed * slider.step:
			if slider.step > 0:
				slider.value += slider.step * sign(input)
			else:
				slider.value += delta * slider_speed * sign(input)
			ControllerHandler.touch_haptic_feedback()
			time_held = 0
	else:
		time_held = 0

func default_behavior(_delta: float) -> void:
	box.modulate = Color(default_color)
	grabber.visible = false


func _on_slider_value_changed(value: float) -> void:
	value_changed.emit(value)
	
	if acoustic_feedback and not slider_sfx.playing:
		slider_sfx.play()

func _on_drag_started() -> void:
	currently_used = true

func _on_drag_ended(_value_changed: bool) -> void:
	currently_used = false

func is_being_used() -> bool:
	return currently_used
