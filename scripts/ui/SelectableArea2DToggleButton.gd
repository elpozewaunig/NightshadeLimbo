extends SelectableArea2DButton
class_name SelectableArea2DToggleButton

@export var selected_toggled_color : Color = Color("eb0033")
@export var default_toggled_color : Color = Color("ff4953")

var active = false

signal toggled(active)

func selection_behavior(delta: float) -> void:
	super.selection_behavior(delta)
	if active:
		modulate = Color(selected_toggled_color)

func default_behavior(delta: float) -> void:
	super.default_behavior(delta)
	if active:
		modulate = Color(default_toggled_color)


func click_action() -> void:
	super.click_action()
	active = not active
	toggled.emit(active)
