extends Control

var boxsize = size.x
var maxv = 0

@onready var slider: HSlider = $"../SliderButtonSrc"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	maxv = slider.max_value + slider.min_value * -1


func _on_slider_button_src_value_changed(value: float) -> void:
	var sx = ((value + slider.min_value * -1) / maxv) * boxsize
	if(sx <= 0):
		size.x = 0.01
	else:
		size.x = sx
