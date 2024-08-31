extends Area2DButton

var game_scene = preload("res://scenes/main.tscn")

func _on_clicked():
	$"../AudioStreamPlayer2D".play()
	$"../../ScaryClick".visible = true
	await get_tree().create_timer(0.4).timeout # tubele
	get_tree().change_scene_to_packed(game_scene)
