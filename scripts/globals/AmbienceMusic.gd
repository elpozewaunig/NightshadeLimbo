extends AudioStreamPlayer

var default_volume : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	default_volume = volume_db


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func reset_volume():
	volume_db = default_volume
