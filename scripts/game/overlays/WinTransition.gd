extends Sprite2D

@export var duration : float = 2.0

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
			SceneManager.change_scene(SceneManager.endscene_scene)
		


func _on_player_exited() -> void:
	transition = true
	modulate.a = 0
	show()