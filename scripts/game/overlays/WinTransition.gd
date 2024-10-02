extends ColorRect

@export var duration : float = 3.0
@export var ftb_duration : float = 1.0

var transition : bool = false
var fade_to_black : bool = false

var ftb_time_elapsed : float = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if transition:
		
		# Fade white screen in
		if not fade_to_black:
			color.a += delta / duration
			if color.a >= 1:
				color.a = 1
				fade_to_black = true
		
		# Gradually change white to black through modulate
		if fade_to_black:
			ftb_time_elapsed += delta
			color = Color("ffffff").lerp(Color("000000"), ftb_time_elapsed / ftb_duration)
			
			if ftb_time_elapsed >= ftb_duration:
				color = Color("000000")
				transition = false
				if Data.remnant_attempt:
					SceneManager.change_scene(SceneManager.endscene_scene_remnant)
				else:
					SceneManager.change_scene(SceneManager.endscene_scene)


func _on_player_exited() -> void:
	transition = true
	color.a = 0
	show()
