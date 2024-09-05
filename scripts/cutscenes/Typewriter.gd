extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


@export var Pitch:float = 1.00
@export var PitchRange:float = 0.05
@export var TypeSpeed:float = 0.3

@onready var label:Label = $Label
@onready var audioplayer:AudioStreamPlayer2D = $TypewriterAudio
@onready var effect = AudioServer.get_bus_effect(1,0) # 2nd bus, 1st effect

# Called every frame. 'delta' is the elapsed time since the previous frame.
var vis_char = 0
func _process(delta: float) -> void:
	if label.visible_ratio < 1:
		label.visible_ratio += TypeSpeed * delta

	if vis_char != label.visible_characters:
		vis_char = label.visible_characters
		
		if audioplayer.stream != null:
			effect.pitch_scale = randf_range(Pitch-PitchRange,Pitch+PitchRange)
			
			audioplayer.play()

func reset():
	label.visible_ratio = 0
	vis_char = 0
