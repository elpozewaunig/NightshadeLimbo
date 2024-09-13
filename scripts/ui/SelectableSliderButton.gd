extends SelectableButton

signal value_changed(value)

@export var acoustic_feedback : bool = true

@onready var slider : HSlider = $SliderButtonSrc
@onready var slider_sfx : AudioStreamPlayer = $SliderSFX
@onready var box : Sprite2D = $Box
@onready var grabber = $White2

var slider_speed : float = 30
var time_held : float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# If the button is selected (either through the mouse or key input)
	if is_visible_in_tree() and is_selected() and not disabled:
		box.modulate = Color("ff7070")
		grabber.visible = true
		
		var input = Input.get_axis("ui_left", "ui_right")
		var just_pressed = Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right")
		if input:
			# Require keeping the action pressed for some time before making a fixed-step adjustment
			time_held += delta
			if just_pressed or time_held > 1 / slider_speed * slider.step:
				slider.value += slider.step * sign(input)
				time_held = 0
		else:
			time_held = 0
		
	# Button is not selected
	else:
		box.modulate = Color("ffffff")
		grabber.visible = false

func _on_slider_value_changed(value: float) -> void:
	value_changed.emit(value)
	
	if acoustic_feedback and not slider_sfx.playing:
		slider_sfx.play()
