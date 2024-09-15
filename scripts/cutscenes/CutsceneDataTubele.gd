extends Resource
class_name CutsceneDataTubele

@export var visualAssetScene: PackedScene = null
@export_multiline var displayText: String = ""
@export var typewriterPitch: float = 1
@export var typewriterPitchRange: float = 0.05
@export var typewriterSpeed: float = 0.3
@export var typewriterSound: AudioStream = null
@export var playMusic: bool = true
@export var loopMusic: bool = true
@export var musicChange: AudioStream = null
@export var overrideSkipTime: float = -1 #-1 for no forced-watch-cutscene
@export var fontSizeOverride: int = 35
# To leave music unchanged:
# playMusic = true
# musicChange = null

# To stop music:
# playMusic = false

# To change music:
# playMusic = true
# mcusicChange = ../resource
