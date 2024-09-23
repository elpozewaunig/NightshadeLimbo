extends Node2D

@onready var fade_out = $FadeOut
@onready var menu = $PauseMenu

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
			
		# No submenu is active, so the player sees the "main" pause menu
		elif menu.visible:
			_on_continue_button_clicked()
	
	if transition:
		fade_out.modulate.a += delta
		if fade_out.modulate.a >= 1:
			fade_out.modulate.a = 1
			SceneManager.change_scene(SceneManager.menu_scene)

func pause(target : bool) -> void:
	get_tree().paused = target


func _on_pause_touch_button_pressed() -> void:
	pause(true)

func _on_continue_button_clicked() -> void:
	pause(false)

func _on_exit_button_clicked() -> void:
	transition = true
