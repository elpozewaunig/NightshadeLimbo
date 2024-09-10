extends Sprite2D

@export var duration : float = 3.0
@export var ftb_duration : float = 1.0

var transition : bool = false
var fade_to_black : bool = false

var ftb_time_elapsed : float = 0

signal disable_lights

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if transition:
		
		# Fade white screen in
		if not fade_to_black:
			modulate.a += delta / duration
			if modulate.a >= 1:
				modulate.a = 1
				fade_to_black = true
				disable_lights.emit()
		
		# Gradually change white to black through modulate
		if fade_to_black:
			ftb_time_elapsed += delta
			modulate = Color("ffffff").lerp(Color("000000"), ftb_time_elapsed / ftb_duration)
			
			if ftb_time_elapsed >= ftb_duration:
				modulate = Color("000000")
				transition = false
				SceneManager.change_scene(SceneManager.endscene_scene)


func _on_player_exited() -> void:
	transition = true
	modulate.a = 0
	show()
