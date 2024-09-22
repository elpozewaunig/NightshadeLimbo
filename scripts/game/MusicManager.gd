extends Node2D

# Must point to boss to configure own track dictionary with correct attacks
@export var boss : Boss

@export var silence_level : float = -100

var tracks = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set up tracks after boss attack data becomes avaiable
	tracks = {
		"default": {"stream": $Background, "active": true},
		boss.Attacks.SALVO: {"stream": $Bullets, "active": false},
		boss.Attacks.BEAM: {"stream": $Laser, "active": false},
		boss.Attacks.ARTILLERY: {"stream": $Bullets, "active": false},
		boss.Attacks.VINE: {"stream": $Vines, "active": false},
		boss.Attacks.JUMP: {"stream": $Jump, "active": false},
		boss.Attacks.DASH: {"stream": $Jump, "active": false}
	}
	
	# Iterate through all tracks
	# Store volume setting from editor to return to via code
	for track_name in tracks:
		var track = tracks[track_name]["stream"]
		tracks[track_name]["volume"] = track.volume_db


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var streams_handled = []
	
	for track_name in tracks:
		var stream = tracks[track_name]["stream"]
		var active = tracks[track_name]["active"]
		var target_volume = tracks[track_name]["volume"]
		
		# If track is disabled, reduce its volume continously until it falls silent
		if not stream_active_anywhere(track_name) and not streams_handled.has(stream) and stream.volume_db > silence_level:
			stream.volume_db -= delta * 50
			streams_handled.append(stream)
			if stream.volume_db < silence_level:
				stream.volume_db = silence_level
		
		# If track is enabled, increease its volume up to its target volume
		elif active and not streams_handled.has(stream) and stream.volume_db < target_volume:
			stream.volume_db += delta * 100
			streams_handled.append(stream)
			if stream.volume_db > target_volume:
				stream.volume_db = target_volume

func stream_active_anywhere(check_track_name) -> bool:
	var stream = tracks[check_track_name]["stream"]
	
	for track_name in tracks:
		var track = tracks[track_name]
		# If track controls same stream and is active
		if track["stream"] == stream and track["active"]:
			return true
			
	return false


func _on_boss_attack_status_changed(attack: Boss.Attacks, status: bool) -> void:
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
