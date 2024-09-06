extends Area2D

signal player_exited

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_exited.emit()
