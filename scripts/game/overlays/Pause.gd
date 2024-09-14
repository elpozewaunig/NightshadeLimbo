extends Node2D

@onready var fade_out = $FadeOut

var transition = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var paused = get_tree().paused
	if paused:
		show()
	else:
		hide()
	
	# Toggle pause on button press
	if Input.is_action_just_pressed("game_pause") and not transition:
		if not paused:
			pause(true)
		else:
			pause(false)
	
	if transition:
		fade_out.modulate.a += delta
		if fade_out.modulate.a >= 1:
			fade_out.modulate.a = 1
			SceneManager.change_scene(SceneManager.menu_scene)

func pause(target : bool) -> void:
	get_tree().paused = target


func _on_continue_button_clicked() -> void:
	pause(false)
	Data.refresh_run_mode()


func _on_exit_button_clicked() -> void:
	transition = true
