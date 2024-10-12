@tool
extends Node2D

@export var enabled : bool = true
@export var mimic_src : Sprite2D
var occluders : Array[LightOccluder2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	occluders.clear()
	for child in get_children():
		occluders.append(child)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if mimic_src != null and enabled:
		
		var current = null
		# If an occluder matching the current frame exists
		if mimic_src.frame < occluders.size():
			# Select current occluder frame
			current = occluders[mimic_src.frame]
		
		# Hide all irrelevant occluders
		for occluder in occluders:
			if occluder == current:
				occluder.show()
			else:
				occluder.hide()
		
		if not current == null:
			# Mimic all relevant properties
			current.global_position = mimic_src.global_position
			current.scale = mimic_src.scale
			current.rotation = mimic_src.rotation
			current.visible = mimic_src.is_visible_in_tree()


func _on_child_order_changed() -> void:
	_ready()
