extends SelectableButton

signal value_changed(value)

@onready var slider = $SliderButtonSrc

func _on_slider_value_changed(value: float) -> void:
	value_changed.emit(value)
