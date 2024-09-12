extends Control

var boxsize = 0
var maxv = 0
var minv = 0

@onready var slider: SliderButtonSrc = $"../SliderButtonSrc"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boxsize = size.x
	maxv = slider.max_value + slider.min_value * -1
	minv = 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_slider_button_src_value_changed(value: float) -> void:
	var sx = ((value + slider.min_value * -1) / maxv) * boxsize
	if(sx <= 0):
		size.x = 0.01
	else:
		size.x = sx
