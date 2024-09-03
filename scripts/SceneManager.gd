extends Node

const game_scene = "res://scenes/main.tscn"
const menu_scene = "res://scenes/main_menu.tscn"
const cutscene_scene = "res://scenes/cutscenes/cutsceneMASTER.tscn"
const endscene_scene = "res://scenes/cutscenes/cutsceneMASTERENDING.tscn"

var switch_to
const loading_scene = preload("res://scenes/loading_screen.tscn")

func change_scene(scene_name : String, loading_screen : bool = false) -> void:
	if loading_screen:
		switch_to = scene_name
		get_tree().change_scene_to_packed(loading_scene)
	
	else:
		get_tree().change_scene_to_packed(load(scene_name))
