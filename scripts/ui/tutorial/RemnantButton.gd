extends SelectableArea2DToggleButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	active = Data.ghost_active

func _on_toggled(status: bool) -> void:
	Data.ghost_active = status
