extends Resource
class_name CutsceneDataTubele

@export var visual_asset_scene: PackedScene = null
@export_multiline var display_text: String = ""
@export var typewriter_pitch: float = 1
@export var typewriter_pitch_range: float = 0.05
@export var typewriter_speed: float = 0.3
@export var typewriter_sound: AudioStream = null
@export var play_music: bool = true
@export var loop_music: bool = true
@export var music_change: AudioStream = null
@export var override_skip_time: float = -1 #-1 for no forced-watch-cutscene
@export var font_size_override: int = 35

# To leave music unchanged:
# play_music = true
# music_change = null

# To stop music:
# play_music = false

# To change music:
# play_music = true
# music_change = ../resource
