extends Node2D

@onready var tracks = {
	"default": {"stream": $Background, "active": true},
	"bullets": {"stream": $Bullets, "active": false},
	"laser": {"stream": $Laser, "active": false},
	"vines": {"stream": $Vines, "active": false}
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for track_name in tracks:
		var track = tracks[track_name]["stream"]
		track.play()
		if not tracks[track_name]["active"]:
			track.volume_db = -50


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for track_name in tracks:
		var track = tracks[track_name]["stream"]
		var active = tracks[track_name]["active"]
		
		# If track is disabled, reduce its volume continously until it falls silent
		if not active and track.volume_db > -50:
			track.volume_db -= delta * 100
			if track.volume_db < -50:
				track.volume_db = -50
		
		# If track is enabled, reduce its volume up to zero db
		elif active and track.volume_db < 0:
			track.volume_db += delta * 100
			if track.volume_db > 0:
				track.volume_db = 0


func _on_boss_attack_status_changed(attack: String, status: bool) -> void:
	if(attack == "salvo"):
		tracks["bullets"]["active"] = status
	elif(attack == "beam"):
		tracks["laser"]["active"] = status
