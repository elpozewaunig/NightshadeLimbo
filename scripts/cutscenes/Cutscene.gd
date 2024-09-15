extends Node2D

@export var cutscene_data: Array[CutsceneDataTubele]


@onready var holdskipcounter = 0
@onready var cutscene_skip_bar = $Control/HBoxContainer/RightRibbon/HoldToSkip/ProgressBar
@onready var label = $Control/HBoxContainer/VBoxContainer/Text/Label
@onready var visual_asset_parent = $Control/HBoxContainer/VBoxContainer/Picture
@onready var typewriter = $Control/HBoxContainer/VBoxContainer/Text
@onready var typewriteraudio = $Control/HBoxContainer/VBoxContainer/Text/TypewriterAudio
@onready var musicplayer = $MusicPlayer
@onready var click_next_hint = $Control/HBoxContainer/LeftRibbon/ClickNextHint
@onready var click_next_hint_anim = $Control/HBoxContainer/LeftRibbon/ClickNextHint/AnimationPlayer

@export var load_on_skip : PackedScene
@export var loading_screen = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	next_cutscene()

var nocutsceneflag = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if nocutsceneflag:
		load_main()
	
	if timesleep_override > 0:
		timesleep_override -= delta
		
	# Hold to skip?
	if Input.is_action_pressed("cutscene_skip"):
		holdskipcounter += delta
		cutscene_skip_bar.value = holdskipcounter
	else:
		holdskipcounter = 0 #reset progress bar if let go prematurely
		cutscene_skip_bar.value = 0
	# (He held to skip)
	if(holdskipcounter>cutscene_skip_bar.max_value):
		load_main()
	
	# Player clicks
	if Input.is_action_just_pressed("cutscene_click"):
		# Typewriter is done, next slide please
		if label.visible_ratio == 1 and timesleep_override <= 0:
			next_cutscene()
		else: # Typewriter isn't done; Show full text without typewriter   
			label.visible_ratio = 1
	
	if label.visible_ratio == 1 and timesleep_override <= 0:
		click_next_hint_anim.play("blink")
		


func load_main():
	SceneManager.change_scene(load_on_skip, loading_screen)


var i = 0
var prevmusic = false
var timesleep_override = -1

func next_cutscene():
	
	if i >= cutscene_data.size():
		nocutsceneflag = true
		return
		
	for c in visual_asset_parent.get_children():
		visual_asset_parent.remove_child(c)

		
	
	if cutscene_data[i]["visual_asset_scene"] != null:
		var child = cutscene_data[i]["visual_asset_scene"].instantiate()
		visual_asset_parent.add_child(child)
	
	label.text = cutscene_data[i]["display_text"]
	label.add_theme_font_size_override("font_size", cutscene_data[i]["font_size_override"])
	
	typewriter.reset()
	typewriter.type_speed = cutscene_data[i]["typewriter_speed"]
	
	typewriter.pitch = cutscene_data[i]["typewriter_pitch"]
	typewriter.pitch_range = cutscene_data[i]["typewriter_pitch_range"]
	typewriteraudio.stream = cutscene_data[i]["typewriter_sound"]
	
	if cutscene_data[i]["music_change"] != null:
		musicplayer.stream = cutscene_data[i]["music_change"]
		musicplayer.playing = cutscene_data[i]["play_music"]
		
	if not cutscene_data[i]["play_music"]:
		musicplayer.playing = false
	
	if musicplayer.stream != null:
		musicplayer.stream.loop = cutscene_data[i]["loop_music"]
	
	
	click_next_hint_anim.play("RESET")
	
	timesleep_override = cutscene_data[i]["override_skip_time"]
	
	i += 1
