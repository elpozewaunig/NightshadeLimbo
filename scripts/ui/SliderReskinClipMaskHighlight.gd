extends Control

var posx = 0
var childposx = 0
var maxv = 0
var minv = 0
var posrange = 0
var offset = 0
@export var zeropos:float = -193
@onready var slider: SliderButtonSrc = $"../SliderButtonSrc"
@onready var childt: Node2D = $Ticks
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	maxv = slider.max_value + slider.min_value * -1
	minv = 0
	
	posx = position.x
	posrange = posx + zeropos * -1
	childposx = childt.position.x
	visible = false
	offset = slider.step
	_on_slider_button_src_value_changed(slider.max_value)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_slider_button_src_value_changed(value: float) -> void:
	
	var snorm = 1 - ((value - offset + slider.min_value * -1) / maxv)
	
	position.x = posx - snorm*posrange
	childt.position.x = childposx + snorm*posrange
	

func _on_slider_button_src_mouse_entered() -> void:
	visible = true


func _on_slider_button_src_mouse_exited() -> void:
	visible = false
