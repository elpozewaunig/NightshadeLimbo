extends AudioStreamPlayer

var target_volume : float = volume_db

var scene_transition = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	volume_db -= 20


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Fade in volume
	if volume_db < target_volume and not scene_transition:
		volume_db += delta * 20
		if volume_db > target_volume:
			volume_db = target_volume
	
	# Fade out volume when changing scene
	elif scene_transition:
		volume_db -= delta * 10


func _on_start_button_clicked() -> void:
	scene_transition = true

func _on_quit_button_clicked() -> void:
	scene_transition = true
