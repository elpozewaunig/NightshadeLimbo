extends Node2D

@export var cutscene_data: Array[CutsceneDataTubele]


@onready var holdskipcounter = 0
@onready var cutsceneSkipBar = $Control/HBoxContainer/RightRibbon/HoldToSkip/ProgressBar
@onready var label = $Control/HBoxContainer/VBoxContainer/Text/Label
@onready var visualAssetParent = $Control/HBoxContainer/VBoxContainer/Picture
@onready var typewriter = $Control/HBoxContainer/VBoxContainer/Text
@onready var typewriteraudio = $Control/HBoxContainer/VBoxContainer/Text/TypewriterAudio
@onready var musicplayer = $MusicPlayer
@onready var clickNextHint = $Control/HBoxContainer/LeftRibbon/ClickNextHint
@onready var clickNextHintAnim = $Control/HBoxContainer/LeftRibbon/ClickNextHint/AnimationPlayer

@export var loadOnSkip = SceneManager.game_scene
@export var loadingScreen = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	next_cutscene()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Hold to skip?
	if Input.is_action_pressed("cutscene_skip"):
		holdskipcounter += delta
		cutsceneSkipBar.value = holdskipcounter
	else:
		holdskipcounter = 0 #reset progress bar if let go prematurely
	
	# (He held to skip)
	if(holdskipcounter>cutsceneSkipBar.max_value):
		load_main()
	
	# Player clicks
	if Input.is_action_just_pressed("cutscene_click"):
		# Typewriter is done, next slide please
		if label.visible_ratio == 1:
			next_cutscene()
		else: # Typewriter isn't done; Show full text without typewriter   
			label.visible_ratio = 1
	
	if label.visible_ratio == 1:
		clickNextHintAnim.play("blink")
		


func load_main():
	SceneManager.change_scene(loadOnSkip, loadingScreen)


var i = 0	
var prevmusic = false

func next_cutscene():
	
	if i >= cutscene_data.size():
		load_main()
		return
		
	for c in visualAssetParent.get_children():
		visualAssetParent.remove_child(c)

		
	
	if cutscene_data[i]["visualAssetScene"] != null:
		var child = cutscene_data[i]["visualAssetScene"].instantiate()
		visualAssetParent.add_child(child)
	
	label.text = cutscene_data[i]["displayText"]
	
	typewriter.reset()
	typewriter.TypeSpeed = cutscene_data[i]["TypewriterSpeed"]
	
	typewriter.Pitch = cutscene_data[i]["TypewriterPitch"]
	typewriter.PitchRange = cutscene_data[i]["TypewriterPitchRange"]
	typewriteraudio.stream = cutscene_data[i]["TypewriterSound"]
	
	if cutscene_data[i]["MusicChange"] != null:
		musicplayer.stream = cutscene_data[i]["MusicChange"]
		musicplayer.playing = cutscene_data[i]["PlayMusic"]
		
	if not cutscene_data[i]["PlayMusic"]:
		musicplayer.playing = false
	
	if musicplayer.stream != null:
		musicplayer.stream.loop = cutscene_data[i]["LoopMusic"]
	
	
	clickNextHintAnim.play("RESET")
	
	i += 1