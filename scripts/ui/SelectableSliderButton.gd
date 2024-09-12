extends SelectableButton

signal value_changed(value)

@export var acoustic_feedback : bool = true

@onready var slider : HSlider = $SliderButtonSrc
@onready var slider_sfx : AudioStreamPlayer = $SliderSFX
@onready var box : Sprite2D = $Box
@onready var grabber = $White2

var slider_speed : float = 20

func _process(delta: float) -> void:
	
	# If the button is selected (either through the mouse or key input)
	if is_visible_in_tree() and is_selected() and not disabled:
		box.modulate = Color("ff7070")
		grabber.visible = true
		
		if Input.is_action_pressed("ui_left"):
			slider.value -= delta * slider_speed
		if Input.is_action_pressed("ui_right"):
			slider.value += delta * slider_speed
			
	# Button is not selected
	else:
		box.modulate = Color("ffffff")
		grabber.visible = false

func _on_slider_value_changed(value: float) -> void:
	value_changed.emit(value)
	
	if acoustic_feedback and not slider_sfx.playing:
		slider_sfx.play()
