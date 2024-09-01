extends StaticBody2D

@onready var timeline = $AttackTimeline
@onready var animation = $TOMATO/AnimationPlayer
@onready var dmg_zone = $DamageZone

var projectile_scene = preload("res://scenes/boss_attacks/projectile.tscn")
var beam_scene = preload("res://scenes/boss_attacks/beam_attack.tscn")
var vine_scene = preload("res://scenes/boss_attacks/vine_attack.tscn")
var impact_scene = preload("res://scenes/boss_attacks/jump_impact.tscn")

# Stores necessary data for firing bullets
var salvos = {}
var salvo_id = 0

# Stores simple countdown for each attack to trigger actions upon completion
var beams = []
var vines = []

var jumping = false
var jump_end_anim = false
var jump_target
var jump_duration = 0
var jump_speed = 0

var game_over = false
var intro_over = false

signal attack_status_changed(attack, status)
signal player_hit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if intro_over and not game_over:
		
		# Iterate through all current salvos
		for key in salvos:
			# Get salvo and associated progress
			var salvo_targets = salvos[key]["targets"]
			var shot_nr = salvos[key]["shot"]
			# If the salvo isn't completed yet
			if shot_nr < salvo_targets.size():
				# Reduce the salvo's countdown until the next shot
				salvos[key]["countdown"] -= delta
				
				if salvos[key]["countdown"] <= 0:
					# Reset countdown for next projectile
					salvos[key]["countdown"] = salvos[key]["interval"]
					
					# Fire the next projectile in the salvo
					_add_projectile(salvos[key]["targets"][shot_nr])
					salvos[key]["shot"] += 1
			else:
				# Delete salvo to free up ressources
				salvos.erase(key)
				if salvos.is_empty():
					emit_signal("attack_status_changed","salvo", false)
		
		# Iterate through all beams and count down their remaining time
		for i in range(0, beams.size()):
			beams[i] -= delta
			# Remove expired beams
			if beams[i] <= 0:
				beams.remove_at(i)
				if beams.is_empty():
					emit_signal("attack_status_changed", "beam", false)
		
		# Iterate through all vines and count down their remaining time
		for i in range(0, vines.size()):
			vines[i] -= delta
			# Remove expired beams
			if vines[i] <= 0:
				vines.remove_at(i)
				if vines.is_empty():
					emit_signal("attack_status_changed", "vine", false)
		
		if jumping:
			dmg_zone.monitoring = false
			jump_duration -= delta
			global_position.move_toward(jump_target, jump_speed * delta)
			if jump_duration <= 0.5 and not jump_end_anim:
				animation.play("JumpAttack_END")
				jump_end_anim = true
			if jump_duration <= 0:
				global_position = jump_target
				jumping = false
				add_child(impact_scene.instantiate())
				dmg_zone.monitoring = true
				emit_signal("attack_status_changed", "jump", false)

# Enqueues a salvo to fire
func salvo(from_pos: Vector2, to_pos: Vector2, amount: int = 20, duration: float = 4) -> void:
	_create_salvo(from_pos, to_pos, amount, duration)

func machine_gun(to_pos: Vector2, amount: int = 20, duration: float = 2) -> void:
	_create_salvo(to_pos, to_pos, amount, duration)

# Creates a beam instance and fires it
func beam(to_pos: Vector2, duration: float = 0.5) -> void:
	var new_beam = beam_scene.instantiate()
	new_beam.target_pos = to_pos
	new_beam.duration = duration
	add_child(new_beam)
	beams.append(duration)
	emit_signal("attack_status_changed", "beam", true)

func vine(points: Array, duration: float = 2) -> void:
	var new_vine = vine_scene.instantiate()
	new_vine.points = points
	new_vine.duration = duration
	add_child(new_vine)
	vines.append(duration)
	emit_signal("attack_status_changed", "vine", true)

func jump(to_pos: Vector2, duration: float = 2) -> void:
	animation.play("JumpAttack_START")
	jumping = true
	jump_end_anim = false
	jump_target = to_pos
	jump_duration = duration
	jump_speed = global_position.distance_to(to_pos) / duration
	emit_signal("attack_status_changed", "jump", true)

# Creates a projectile instance and fires it
func _add_projectile(global_pos_to: Vector2) -> void:
	var projectile = projectile_scene.instantiate()
	projectile.target_pos = global_pos_to
	add_child(projectile)

# Adds a salvo to salvos array
func _create_salvo(from_pos: Vector2, to_pos: Vector2, amount: int, duration: float) -> void:
	var projectiles : Array[Vector2] = []
	var offset = to_pos - from_pos
	for i in range(0, amount):
		var target_pos_x = from_pos.x + (offset.x / amount) * i
		var target_pos_y = from_pos.y + (offset.y / amount) * i
		projectiles.append(Vector2(target_pos_x, target_pos_y))
		
	salvos[salvo_id] = {
	"targets": projectiles,
	"shot": 0,
	"interval": duration / amount,
	"countdown": 0
	}
	salvo_id += 1
	emit_signal("attack_status_changed", "salvo", true)


func _on_game_over() -> void:
	game_over = true
	timeline.pause()
	animation.clear_queue()
	animation.play("PlayerHasDied")
	

func _on_intro_done() -> void:
	intro_over = true
	timeline.play("salvos_1")


func _on_damage_zone_entered(body: Node2D) -> void:
	if body.name == "Player":
		emit_signal("player_hit")
