extends Node

const game_scene = "res://scenes/main.tscn"
const menu_scene = "res://scenes/main_menu.tscn"
const cutscene_scene = "res://scenes/cutscenes/cutscene_scene.tscn"
const endscene_scene = "res://scenes/cutscenes/endscene_scene.tscn"

const loading_scene = preload("res://scenes/loading_screen.tscn")

func change_scene(scene_name : String, loading_screen : bool = false) -> void:
	if loading_screen:
		# Create loading scene and add it as a parallel scene
		var loader = loading_scene.instantiate()
		loader.scene_to_load = scene_name
		get_tree().root.add_child(loader)
		
		# Delete current main scene at the end of the frame
		get_tree().current_scene.queue_free()
		get_tree().current_scene = loader
	
	else:
		get_tree().change_scene_to_packed(load(scene_name))

func quit_game():
	get_tree().quit()
