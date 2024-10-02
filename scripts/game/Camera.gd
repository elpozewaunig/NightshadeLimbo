extends Camera2D

@onready var overlays = $Overlays

@export var shake_fps : float = 30
@export var max_shake : Vector2 = Vector2(50, 50)

var shaking : bool = false
var neutral_zoom : Vector2 = zoom
var neutral_pos : Vector2 = position

var time_elapsed : float = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Sync scale of overlays with camera zoom
	overlays.scale.x = 1 / zoom.x
	overlays.scale.y = 1 / zoom.y
	
	# Handle shake
	if shaking:
		zoom = zoom.move_toward(Vector2(1, 1), delta)
		
		# Do a shake movement in intervals according to the specified fps
		time_elapsed += delta
		if time_elapsed > 1 / shake_fps:
			position.x = randf_range(-max_shake.x, max_shake.x) + neutral_pos.x
			position.y = randf_range(-max_shake.y, max_shake.y) + neutral_pos.y
	
	# Reset to default position
	else:
		zoom = zoom.move_toward(neutral_zoom, delta * 2)
		position = position.move_toward(neutral_pos, delta * 2)
		time_elapsed = 0


func _on_set_shake(active : bool) -> void:
	shaking = active
