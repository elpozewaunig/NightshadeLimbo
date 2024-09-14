extends SelectableArea2DToggleButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	active = Data.remnant_active

func _on_toggled(status: bool) -> void:
	Data.remnant_active = status
