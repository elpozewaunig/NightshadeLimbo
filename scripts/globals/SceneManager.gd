extends Node

@export_group("Scenes")
@export var game_scene : PackedScene
@export var menu_scene : PackedScene
@export var cutscene_scene : PackedScene
@export var endscene_scene : PackedScene
@export var endscene_scene_remnant : PackedScene

@export_group("Loading Screen")
@export var loading_scene : PackedScene


func change_scene(scene: PackedScene, loading_screen: bool = false) -> void:
	if scene != game_scene:
		AmbienceMusic.stop()
	
	if loading_screen:
		# Create loading scene and add it as a parallel scene
		var loader = loading_scene.instantiate()
		loader.scene_path = scene.resource_path
		get_tree().root.add_child(loader)
		
		# Delete current main scene at the end of the frame
		get_tree().current_scene.queue_free()
		get_tree().current_scene = loader
	
	else:
		# Instantly load and change to scene
		get_tree().change_scene_to_packed(scene)
	
	# Make sure game is unpaused after scene switch
	get_tree().paused = false

func quit_game():
	get_tree().quit()
