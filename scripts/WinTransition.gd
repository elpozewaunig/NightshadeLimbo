extends Sprite2D

@export var duration : float = 2.0
@onready var outro_scene = preload("res://scenes/cutscenes/cutsceneMASTERENDING.tscn")

var transition = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if transition:
		modulate.a += delta / duration
		if modulate.a >= 1:
			modulate.a = 1
			transition = false
			get_tree().change_scene_to_packed(outro_scene)
		


func _on_player_exited() -> void:
	transition = true
	modulate.a = 0
	show()
