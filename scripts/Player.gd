extends CharacterBody2D


const SPEED = 500.0


func _ready() -> void:
	motion_mode = MOTION_MODE_FLOATING

func _physics_process(_delta: float) -> void:
	# Get the x-axis input direction and handle the movement/deceleration.
	var x_movement := Input.get_axis("ui_left", "ui_right")
	if x_movement:
		velocity.x = x_movement * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Get the y-axis input direction and handle the movement/deceleration.
	var y_movement := Input.get_axis("ui_up", "ui_down")
	if y_movement:
		velocity.y = y_movement * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	move_and_slide()

func _on_projectile_hit() -> void:
	pass

func _on_beam_hit() -> void:
	pass
