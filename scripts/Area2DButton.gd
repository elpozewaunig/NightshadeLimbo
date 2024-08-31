extends Area2D
class_name Area2DButton

var mouse_inside = false

@onready var sprite = $AnimatedSprite2D
@onready var label = $Label

signal clicked

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if mouse_inside:
		label.modulate = Color("1c1c1c")
		
		if Input.is_action_just_pressed("ui_click"):
			emit_signal("clicked")
			
	else:
		label.modulate = Color("ffffff")


func _on_mouse_entered() -> void:
	mouse_inside = true

func _on_mouse_exited() -> void:
	mouse_inside = false

func _on_clicked() -> void:
	pass # Replace with function body.
