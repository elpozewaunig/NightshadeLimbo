extends Area2DButton

var game_scene = preload("res://scenes/main.tscn")

func _on_clicked():
	get_tree().change_scene_to_packed(game_scene)
