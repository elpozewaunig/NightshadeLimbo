extends Sprite2D

var current : int = 0
var playback_data : Array[Dictionary]

var stored_alpha : float

var enabled : bool = Data.remnant_active
var playback_active : bool = false
var time_elapsed : float = 0
var dead : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# By default, the current run is no remnant attempt.
	Data.remnant_attempt = false
	
	playback_data = Data.remnant_data
	if not playback_data.is_empty():
		global_position = playback_data[0]["position"]
	
	stored_alpha = modulate.a
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Playback not fully played yet, actual player is still alive
	if current < playback_data.size() and not dead:
		
		if playback_active:
			time_elapsed += delta
			
			# Update visibility based on remnant setting
			if enabled:
				# Flag attempt as remnant attempt
				Data.remnant_attempt = true
				show()
			else:
				hide()
			
			# Advance through frames while they are covered by the current time elapsed
			while current < playback_data.size() and time_elapsed >= playback_data[current]["delta"]:
				time_elapsed -= playback_data[current]["delta"]
				global_position = playback_data[current]["position"]
				current += 1
			
			# There is another recording point, which isn't covered by the current time elapsed yet
			if current + 1 < playback_data.size():
				# Interpolate towards the next point using the elapsed time
				global_position = lerp(global_position, playback_data[current + 1]["position"], time_elapsed / playback_data[current + 1]["delta"])
	
	# Playback finished or player died
	else:
		modulate.a -= delta * stored_alpha
		if modulate.a <= 0:
			modulate.a = 0
			hide()


func _on_permit_movement() -> void:
	# Start playback as soon as the player is allowed to move.
	# This is equal to the point in time when the player begins recording.
	playback_active = true

func _on_game_over() -> void:
	dead = true


func _on_remnant_playback_toggled(active: bool) -> void:
	enabled = active
