extends CharacterBody2D
class_name Player

@onready var animation : AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var weapon : Area2D = $Weapon
@onready var death_sfx : AudioStreamPlayer = $DeathSFX

const SPEED : float = 500.0
const DECEL_TIME : float = 0.1

var speed_debuff : float = 0
var reset_debuff : bool = false
var permit_movement : bool = false
var boss_defeated : bool = false
var escaped : bool = false

var dead : bool = false
var fight_back : bool = false

var remnant_data : Array[Dictionary] = []
var timer_active : bool = false
var time_spent : float = 0

signal game_over
signal boss_hit

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	# If timer has started for stat recording
	if timer_active:
		time_spent += delta
	
	# If flag to reset the slowdown has been set
	if reset_debuff:
		# Gradually decrease debuff
		speed_debuff -= delta * 500
		if speed_debuff <= 0:
			speed_debuff = 0
			reset_debuff = false
	
	# Get axis input
	var x_input := Input.get_axis("game_left", "game_right")
	var y_input := Input.get_axis("game_up", "game_down")
	
	# Allow player to turn even when not allowing movement
	if x_input and not dead and not escaped:
		# Flip sprite depending on input to left or right
		sprite.flip_h = x_input < 0
	
	# Movement script
	if permit_movement and not dead:
		# Record current position and delta for remnant playback
		if not boss_defeated:
			remnant_data.append({"position": global_position, "delta": delta})
		
		# When both directions are active, the player might exceed maximum speed
		# To compensate for this, normalize the input vector
		var normalized_input := Vector2(x_input, y_input).normalized()
		
		# Handle x-axis movement/deceleration
		if normalized_input.x:
			velocity.x = normalized_input.x * (SPEED - speed_debuff)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED / DECEL_TIME  * delta)
		
		# Handle y-axis movement/deceleration
		if normalized_input.y:
			velocity.y = normalized_input.y * (SPEED - speed_debuff)
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED / DECEL_TIME * delta)
		
		move_and_slide()
		
		if Input.is_action_just_pressed("game_attack"):
			if fight_back:
				animation.play("attack")
				animation.queue("chibicycle")
	
	# If the player is in a phase where he can attack
	if fight_back:
		weapon.show()
		weapon.modulate.a += delta * 3
		if weapon.modulate.a >= 1:
			weapon.modulate.a = 1
		
	else:
		weapon.modulate.a -= delta * 3
		if weapon.modulate.a <= 0:
			weapon.modulate.a = 0
			weapon.hide()
	
	# Player has touched exit
	if escaped:
		global_position = global_position.move_toward(Vector2(-300, 540), delta * 200)

func set_game_over() -> void:
	if not dead:
		dead = true
		fight_back = false
		death_sfx.play()
		animation.clear_queue()
		submit_time()
		Input.start_joy_vibration(0, 1, 0, 0.5)
		Data.submit_remnant_data(remnant_data)
		
		# Play random death animation
		if randi() % 2 == 0:
			animation.play("die1")
		else:
			animation.play("die2")
			
		game_over.emit()
		Data.add_death()

func submit_time() -> void:
	timer_active = false
	Data.add_time(time_spent)


func _on_projectile_hit() -> void:
	set_game_over()

func _on_beam_hit() -> void:
	set_game_over()

func _on_vine_hit() -> void:
	set_game_over()

func _on_impact_hit() -> void:
	set_game_over()

func _on_boss_hit() -> void:
	set_game_over()


func _on_intro_permit_movement() -> void:
	permit_movement = true
	timer_active = true
	speed_debuff = 450

func _on_intro_done() -> void:
	reset_debuff = true

func _on_boss_vulnerable_status_changed(vulnerable: bool) -> void:
	if vulnerable:
		fight_back = true
		weapon.modulate.a = 0
	else:
		fight_back = false
		if not dead:
			animation.play("chibicycle")

func _on_chance_missed() -> void:
	permit_movement = false

func _on_weapon_hitbox_entered(body: Node2D) -> void:
	if body.name == "Boss":
		boss_hit.emit()

func _on_boss_defeated() -> void:
	fight_back = false
	animation.play("win")
	permit_movement = false
	boss_defeated = true

func _on_boss_death_permit_move() -> void:
	permit_movement = true
	speed_debuff = 450

func _on_boss_death_done() -> void:
	reset_debuff = true

func _on_player_exited() -> void:
	permit_movement = false
	submit_time()
	escaped = true
