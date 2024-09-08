extends Node2D

var obstacles : Array[StaticBody2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		obstacles.append(child)

func _on_destroy_obstacle(index : int) -> void:
	obstacles[index].destroy()
