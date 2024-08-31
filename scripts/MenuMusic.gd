extends AudioStreamPlayer

var target_volume : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_volume = volume_db
	volume_db -= 20


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if volume_db < target_volume:
		volume_db += delta * 10
		if volume_db > target_volume:
			volume_db = target_volume
