extends CharacterBody2D


const SPEED = 500.0
var speed_debuff = 0
var reset_debuff = false
var permit_movement = false

var dead = false

var time_mouse_idle = 0

signal game_over

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	time_mouse_idle += delta
	
	# Hide mouse automatically if it isn't moved for a long time
	if time_mouse_idle > 5:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	# If flag to reset the slowdown has been set
	if reset_debuff:
		# Gradually decrease debuff
		speed_debuff -= delta * 500
		if speed_debuff <= 0:
			speed_debuff = 0
			reset_debuff = false
	
	if permit_movement and not dead:
		# Get the x-axis input direction and handle the movement/deceleration.
		var x_movement := Input.get_axis("ui_left", "ui_right")
		if x_movement:
			velocity.x = x_movement * (SPEED - speed_debuff)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		# Get the y-axis input direction and handle the movement/deceleration.
		var y_movement := Input.get_axis("ui_up", "ui_down")
		if y_movement:
			velocity.y = y_movement * (SPEED - speed_debuff)
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)
		
		move_and_slide()

func set_game_over() -> void:
	if not dead:
		dead = true
		emit_signal("game_over")

func _on_projectile_hit() -> void:
	set_game_over()

func _on_beam_hit() -> void:
	set_game_over()

func _on_impact_hit() -> void:
	set_game_over()

func _on_intro_done() -> void:
	reset_debuff = true


func _on_intro_permit_movement() -> void:
	permit_movement = true
	speed_debuff = 450

func _input(event):
	# After the mouse is moved, disable the highlight
	if event is InputEventMouseMotion:
		time_mouse_idle = 0
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
