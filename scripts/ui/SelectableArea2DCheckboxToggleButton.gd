extends SelectableArea2DToggleButton
class_name SelectableArea2DCheckboxToggleButton

@onready var check: Sprite2D = $Check

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	
	if active:
		check.show()
	else:
		check.hide()
