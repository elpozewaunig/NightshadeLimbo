extends Node2D

@onready var tutorial = $TutorialSubmenu
@onready var illumination = $Illumination
@onready var black = $Black
@onready var light_sfx = $LightSFX

var music = AmbienceMusic
var game_over = false

var phases = ["BLACK_SCREEN", "GAME_START", "FADE_OUT"] #["TUTORIAL", "BLACK_SCREEN", "GAME_START", "FADE_OUT"]
var time_elapsed = 0
var phase = 0

var tutorial_init = false

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
		"TUTORIAL":
			if not Data.tutorial_seen:
				if not tutorial_init:
					tutorial.show()
					light_sfx.play()
					tutorial_init = true
				
				black.modulate.a -= delta
				if black.modulate.a <= 0:
					black.modulate.a = 0
				
			else:
				black.modulate.a = 1
				tutorial.hide()
				advance_phase()
		
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
				
				# Player did not die during intro
				if not game_over:
					music.stop()
					
				queue_free()

func advance_phase() -> void:
	time_elapsed = 0
	phase += 1


func _on_game_over() -> void:
	game_over = true


func _on_tutorial_closed() -> void:
	Data.tutorial_seen = true
