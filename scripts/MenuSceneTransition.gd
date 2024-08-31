extends Sprite2D

var game_scene = preload("res://scenes/main.tscn")

@export var transition_duration : float = 1.5
var transition = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	modulate.a = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Fade in
	if transition:
		modulate.a += delta / transition_duration
		if modulate.a >= 1:
			modulate.a = 1
			transition = false
			get_tree().change_scene_to_packed(game_scene)

func _on_start_button_clicked():
	transition = true
	show()