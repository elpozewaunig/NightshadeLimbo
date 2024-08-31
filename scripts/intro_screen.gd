extends Node2D

@onready var illumination = $Illumination
@onready var black = $Black

var time_elapsed = 0
var phase = 0

signal intro_done
signal permit_movement

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_elapsed += delta
	
	if phase == 0 and time_elapsed > 1:
		black.hide()
		emit_signal("permit_movement")
		time_elapsed = 0
			
	if phase == 1 and time_elapsed > 1:
		emit_signal("intro_done")
		time_elapsed = 0
	
	if phase == 2:
		illumination.modulate.a -= delta
		if illumination.modulate.a <= 0:
			illumination.modulate.a = 0
			illumination.hide()
			queue_free()
	
	# Automatically advance phases after every timer reset
	if time_elapsed == 0:
		phase += 1
