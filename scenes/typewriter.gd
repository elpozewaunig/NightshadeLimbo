extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.visible_ratio = 0

var vis_char = 0
var flip = true

@export var pitch = 1.00
@export var pitchrange = 0.05
@export var typespeed = 0.3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Label.visible_ratio < 1:
		$Label.visible_ratio += typespeed * delta
	elif flip:
		$"../clickweiterHint/AnimationPlayer".play("blink")
		flip = false
	if vis_char != $Label.visible_characters:
		vis_char = $Label.visible_characters
		
		effect.pitch_scale = randf_range(pitch-pitchrange,pitch+pitchrange)
		
		$AudioStreamPlayer2D.play()
		
var effect = AudioServer.get_bus_effect(1,0) # 2nd bus, 1st effect


#var c = 0
#var v = 1
#func funnypitch1():
#	effect.pitch_scale = 1 + c 
#	c+= 0.01 * v
#	if effect.pitch_scale > 1.25 or effect.pitch_scale < 0.25:
#		c = 0
#		v *= -1
#
#func funnypitch3():
#	effect.pitch_scale = 1 + randf_range(0.5,1.5)	
