extends Node2D

@onready var illumination = $Illumination
@onready var black = $Black
@onready var light_sfx = $LightSFX

var music = AmbienceMusic

var phases = ["BLACK_SCREEN", "GAME_START", "FADE_OUT"]

var time_elapsed = 0
var phase = 0

signal intro_done
signal permit_movement

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not music.playing:
		music.play()
	
	show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_elapsed += delta
	
	match phases[phase]:
		"BLACK_SCREEN":
			if time_elapsed > 1:
				black.hide()
				light_sfx.play()
				permit_movement.emit()
				advance_phase()
		
		"GAME_START":
			if time_elapsed > 1:
				intro_done.emit()
				advance_phase()
		
		"FADE_OUT":
			illumination.modulate.a -= delta
			music.volume_db -= delta * 25
			if illumination.modulate.a <= 0:
				illumination.modulate.a = 0
				illumination.hide()
				music.stop()
				queue_free()

func advance_phase() -> void:
	time_elapsed = 0
	phase += 1
