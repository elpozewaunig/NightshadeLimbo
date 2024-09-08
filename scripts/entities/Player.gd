extends CharacterBody2D

@onready var animation = $Sprite2D/AnimationPlayer
@onready var weapon = $Weapon
@onready var death_sfx = $DeathSFX

const SPEED : float = 500.0
const DECEL_TIME : float = 0.1

var speed_debuff = 0
var reset_debuff = false
var permit_movement = false
var escaped = false

var dead = false
var fight_back = false

signal game_over
signal boss_hit

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	# If flag to reset the slowdown has been set
	if reset_debuff:
		# Gradually decrease debuff
		speed_debuff -= delta * 500
		if speed_debuff <= 0:
			speed_debuff = 0
			reset_debuff = false
	
	if permit_movement and not dead:
		# Get axis input
		var x_input := Input.get_axis("ui_left", "ui_right")
		var y_input := Input.get_axis("ui_up", "ui_down")
		
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
		
		if Input.is_action_just_pressed("game_attack"):
			if fight_back:
				animation.play("attack")
				animation.queue("chibicycle")
		
	# Player has touched exit
	if escaped:
		global_position = global_position.move_toward(Vector2(-300, 540), delta * 200)

func set_game_over() -> void:
	if not dead:
		dead = true
		death_sfx.play()
		
		# Play random death animation
		if randi() % 2 == 0:
			animation.play("die1")
		else:
			animation.play("die2")
			
		game_over.emit()
		Stats.add_death()

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
	speed_debuff = 450

func _on_intro_done() -> void:
	reset_debuff = true

func _on_boss_vulnerable_status_changed(vulnerable: bool) -> void:
	if vulnerable:
		fight_back = true
		weapon.modulate.a = 0
	else:
		fight_back = false
		animation.play("chibicycle")

func _on_weapon_hitbox_entered(body: Node2D) -> void:
	if body.name == "Boss":
		boss_hit.emit()

func _on_boss_defeated() -> void:
	fight_back = false
	animation.play("win")
	permit_movement = false

func _on_boss_death_permit_move() -> void:
	permit_movement = true
	speed_debuff = 450

func _on_boss_death_done() -> void:
	reset_debuff = true

func _on_player_exited() -> void:
	permit_movement = false
	escaped = true
