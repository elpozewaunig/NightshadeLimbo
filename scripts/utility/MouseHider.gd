extends Node2D

@export var disappear_time : float = 4

var time_mouse_idle : float = 0

func _process(delta: float) -> void:
	if not get_tree().paused:
		time_mouse_idle += delta
		
		# Hide mouse automatically if it isn't moved for a long time
		if time_mouse_idle > disappear_time:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	# If the game is paused, don't make the mouse disappear
	else:
		time_mouse_idle = 0

func _input(event):
	# After the mouse is moved, make it visible
	if event is InputEventMouseMotion:
		time_mouse_idle = 0
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
