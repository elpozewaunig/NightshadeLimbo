extends Node2D

@export var nextCutscene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


var holdskipcounter = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("cutscene_skip"):
		holdskipcounter += delta
		$Control/HBoxContainer/Panel3/Label/ProgressBar.value = holdskipcounter
	else:
		holdskipcounter = 0
	if(holdskipcounter>2):
		skip_cutscene()
	if Input.is_action_just_pressed("cutscene_click"):
		if $Control/HBoxContainer/VBoxContainer/Panel2/Typewriter/Label.visible_ratio == 1:
			#optional?
			$Control/HBoxContainer/VBoxContainer/Panel2/clickweiterHint/AnimationPlayer.stop()
			$Control/HBoxContainer/VBoxContainer/Panel2/clickweiterHint/AnimationPlayer.clear_queue()
			
			get_tree().change_scene_to_packed(nextCutscene)
		else:
			$Control/HBoxContainer/VBoxContainer/Panel2/Typewriter/Label.visible_ratio = 1
			
	
	
func skip_cutscene():
	get_tree().change_scene_to_packed(preload("res://scenes/main.tscn"))
