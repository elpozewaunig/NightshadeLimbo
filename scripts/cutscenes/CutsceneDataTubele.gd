extends Resource
class_name CutsceneDataTubele

@export var visualAssetScene: PackedScene = null
@export_multiline var displayText: String = ""
@export var TypewriterPitch: float = 1
@export var TypewriterPitchRange: float = 0.05
@export var TypewriterSpeed: float = 0.3
@export var TypewriterSound: AudioStream = null
@export var PlayMusic: bool = true
@export var LoopMusic: bool = true
@export var MusicChange: AudioStream = null
@export var overrideSkipTime: float = -1

# To leave music unchanged:
# PlayMusic = true
# MusicChange = null

# To stop music:
# PlayMusic = false

# To change music:
# PlayMusic = true
# MusicChange = ../resource
