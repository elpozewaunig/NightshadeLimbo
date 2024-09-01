extends Node2D

@export var mimic_src : Sprite2D
var occluders : Array[LightOccluder2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		occluders.append(child)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Select current occluder frame
	var current = occluders[mimic_src.frame]
	
	# Hide all irrelevant occluders
	for occluder in occluders:
		if occluder == current:
			occluder.show()
		else:
			occluder.hide()
	
	# Mimic all relevant properties
	current.global_position = mimic_src.global_position
	current.scale = mimic_src.scale
	current.rotation = mimic_src.rotation
	current.visible = mimic_src.visible
