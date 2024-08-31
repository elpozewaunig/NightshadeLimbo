extends Area2D

var mouse_inside = false

@onready var sprite = $AnimatedSprite2D
@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if mouse_inside:
		label.modulate = Color("1c1c1c")
	else:
		label.modulate = Color("ffffff")

func _on_input_event(event):
	if (event is InputEventMouseButton && event.is_action_released("click")):
		if mouse_inside:
			onclick_action()


func _on_mouse_entered() -> void:
	mouse_inside = true

func _on_mouse_exited() -> void:
	mouse_inside = false

func onclick_action():
	# To be implemented by extending classes
	pass
