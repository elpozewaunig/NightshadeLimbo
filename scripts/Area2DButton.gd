extends Area2D
class_name Area2DButton

var mouse_inside = false
var highlight_active = false
var ext_selected = false

@onready var sprite = $AnimatedSprite2D
@onready var label = $Label

signal clicked
signal selected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (mouse_inside and not highlight_active) or (ext_selected and highlight_active):
		label.modulate = Color("1c1c1c")
		
		if Input.is_action_just_pressed("ui_click") or Input.is_action_just_pressed("ui_accept"):
			emit_signal("clicked")
			
	else:
		label.modulate = Color("ffffff")


func _on_mouse_entered() -> void:
	mouse_inside = true
	emit_signal("selected", self)

func _on_mouse_exited() -> void:
	mouse_inside = false

func _on_clicked() -> void:
	pass # Replace with function body.

# Triggered by button selector through key/gamepad input
func _on_ext_selected(btn_node):
	if visible:
		highlight_active = true
		if btn_node == self:
			ext_selected = true
			emit_signal("selected", self)
		else:
			ext_selected = false

# Triggered by button selector when the current selection is replaced by mouse movement
func _on_ext_cleared():
	if highlight_active and mouse_inside and visible:
		emit_signal("selected", self)
	highlight_active = false
	ext_selected = false
