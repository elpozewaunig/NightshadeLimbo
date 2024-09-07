extends Node2D

@onready var tracks = {
	"default": {"stream": $Background, "active": true},
	"salvos": {"stream": $Bullets, "active": false},
	"beams": {"stream": $Laser, "active": false},
	"artillery": {"stream": $Bullets, "active": false},
	"vines": {"stream": $Vines, "active": false},
	"jump": {"stream": $Jump, "active": false},
	"dash": {"stream": $Jump, "active": false},
}

@export var silence_level : float = -100
@export var change_speed : float = 300


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Iterate through all tracks
	# Store volume setting from editor to return to via code
	for track_name in tracks:
		var track = tracks[track_name]["stream"]
		tracks[track_name]["volume"] = track.volume_db


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for track_name in tracks:
		var track = tracks[track_name]["stream"]
		var active = tracks[track_name]["active"]
		var target_volume = tracks[track_name]["volume"]
		
		# If track is disabled, reduce its volume continously until it falls silent
		if not active and track.volume_db > silence_level:
			track.volume_db -= delta * 100
			if track.volume_db < silence_level:
				track.volume_db = silence_level
		
		# If track is enabled, reduce its volume up to zero db
		elif active and track.volume_db < target_volume:
			track.volume_db += delta * 100
			if track.volume_db > target_volume:
				track.volume_db = target_volume


func _on_boss_attack_status_changed(attack: String, status: bool) -> void:
	tracks[attack]["active"] = status


func _on_intro_done() -> void:
	# Iterate through all tracks and start playing them in unison
	for track_name in tracks:
		var track = tracks[track_name]["stream"]

		# Silence inactive tracks
		if not tracks[track_name]["active"]:
			track.volume_db = silence_level
		
		track.play()


func _on_game_over() -> void:
	# Disable all tracks
	for track_name in tracks:
		tracks[track_name]["active"] = false


func _on_boss_defeated() -> void:
	for track_name in tracks:
		tracks[track_name]["active"] = false


func _on_boss_death_done() -> void:
	$VictoryJingle.play()
