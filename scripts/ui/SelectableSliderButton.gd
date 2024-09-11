extends SelectableButton

signal value_changed(value)

@export var acoustic_feedback : bool = true

@onready var slider = $SliderButtonSrc
@onready var slider_sfx = $SliderSFX

func _on_slider_value_changed(value: float) -> void:
	value_changed.emit(value)
	
	if acoustic_feedback and not slider_sfx.playing:
		slider_sfx.play()
