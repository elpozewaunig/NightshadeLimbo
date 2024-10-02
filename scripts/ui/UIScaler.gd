extends Node2D

@export var mobile_position : Vector2
@export var mobile_scale : Vector2 = Vector2(1.2, 1.2)
var default_position : Vector2 = position
var default_scale : Vector2 = scale

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ControllerHandler.input_category_changed.connect(_on_input_category_changed)
	_on_input_category_changed(ControllerHandler.category)


func _on_input_category_changed(category: ControllerHandler.Category) -> void:
	if category == ControllerHandler.Category.TOUCH:
		scale = mobile_scale
		position = mobile_position
	
	else:
		scale = default_scale
		position = default_position
