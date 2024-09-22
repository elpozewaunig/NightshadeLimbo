extends StaticBody2D
class_name Boss

@onready var timeline = $AttackTimeline
@onready var animation = $Tomato/AnimationPlayer
@onready var dmg_zone = $DamageZone

@export var player : Player

@export var health : int = 3

@export_group("Attack Scenes")
@export var projectile_scene : PackedScene
@export var beam_scene : PackedScene
@export var artillery_scene : PackedScene
@export var vine_scene : PackedScene
@export var impact_scene : PackedScene

var vulnerable = false
var vulnerable_duration = 0
var dmg_taken = false

enum Attacks {SALVO, BEAM, ARTILLERY, VINE, JUMP, DASH}

# Stores necessary data for firing bullets
var salvos = []

# Stores simple countdown for each attack to trigger actions upon completion
var attack_countdowns = {
	Attacks.BEAM: [],
	Attacks.ARTILLERY: [],
	Attacks.VINE: []
}

var array_delete_queue = []

var jumping = false
var jump_end_anim = false
var dashing = false

var move_target
var move_duration = 0
var move_speed = 0

var game_over = false
var intro_over = false
var dead = false

signal attack_status_changed(attack, status)
signal destroy_obstacle(index)
signal set_shake(active)

signal vulnerable_status_changed(status)
signal player_hit
signal player_died
signal chance_missed
signal defeated

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Create singular bullet and play animation to combat first-time lag on web export
	_add_projectile(global_position, true)
	animation.play("RESET")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if intro_over and not game_over and not dead:
		
		var next_salvos = salvos.duplicate()
		
		# Iterate through all current salvos
		for i in range(0, next_salvos.size()):
			
			# Get salvo and associated progress
			var salvo_targets = next_salvos[i]["targets"]
			var shot_nr = next_salvos[i]["shot"]
			
			# Reduce the salvo's countdown until the next shot
			next_salvos[i]["countdown"] -= delta
			
			# If the salvo isn't completed yet and the next shot is due
			while shot_nr < salvo_targets.size() and next_salvos[i]["countdown"] <= 0:
					
					# Reset countdown based on interval, += to compensate for delta overshoots
					next_salvos[i]["countdown"] += next_salvos[i]["interval"]
					
					# Fire the next projectile in the salvo
					_add_projectile(next_salvos[i]["targets"][shot_nr])
					next_salvos[i]["shot"] += 1
					shot_nr = next_salvos[i]["shot"]
			
			# All shots in the salvo have been fired
			if shot_nr >= salvo_targets.size():
				# Delete salvo to free up ressources
				mark_for_deletion(salvos, i)
		
		# Iterate through all attacks and count down their remaining time
		for attack in attack_countdowns:
			var current_attack = attack_countdowns[attack]
			for i in range(0, current_attack.size()):
				current_attack[i] -= delta
				# Remove expired attacks
				if current_attack[i] <= 0:
					mark_for_deletion(current_attack, i)
		
		# Handle jumping
		if jumping:
			dmg_zone.monitoring = false
			move_duration -= delta
			
			# Start playing jump end animation ahead of time
			if move_duration <= 0.7 and not jump_end_anim:
				global_position = move_target
				animation.play("JumpAttack_END")
				jump_end_anim = true
			
			if move_duration <= 0:
				jumping = false
				jump_end_anim = false
				add_child(impact_scene.instantiate())
				dmg_zone.monitoring = true
				attack_status_changed.emit(Attacks.JUMP, false)
		
		# Handle dashing
		if dashing:
			move_duration -= delta
			global_position = global_position.move_toward(move_target, move_speed * delta)
			
			if move_duration <= 0:
				global_position = move_target
				dashing = false
				attack_status_changed.emit(Attacks.DASH, false)
		
		# Handle vulnerability windows
		if vulnerable:
			vulnerable_duration -= delta
			# Invulnerability has expired
			if vulnerable_duration <= 0:
				if dmg_taken:
					animation.play("TakeDamageDONE")
				else:
					animation.play("Vulnerable_END")
					chance_missed.emit()
					_death_ray()
					player_hit.emit()
					
				vulnerable_duration = 0
				vulnerable = false
				dmg_taken = false
				dmg_zone.monitoring = true
				vulnerable_status_changed.emit(false)
		
		# If boss was just mortally wounded
		if health <= 0:
			dead = true
			defeated.emit()
			dmg_zone.monitoring = false
			timeline.pause()
			hide()
			ControllerHandler.vibrate(0, 1, 1)
			process_mode = PROCESS_MODE_DISABLED
		
	# Delete all array entries that were marked for deletion
	for deletion in array_delete_queue:
		deletion["array"].remove_at(deletion["index"])
	array_delete_queue.clear()
	
	# Emit status signals for attacks that have stopped 
	if salvos.is_empty():
		attack_status_changed.emit(Attacks.SALVO, false)
	
	for attack in attack_countdowns:
		if attack_countdowns[attack].is_empty():
			attack_status_changed.emit(attack, false)

# Enqueues a salvo to fire
func salvo(from_pos: Vector2, to_pos: Vector2, amount: int = 20, duration: float = 4) -> void:
	_create_salvo(from_pos, to_pos, amount, duration)

func machine_gun(to_pos: Vector2, amount: int = 20, duration: float = 2) -> void:
	_create_salvo(to_pos, to_pos, amount, duration)

# Creates a beam instance and fires it
func beam(to_pos: Vector2, duration: float = 0.5) -> void:
	moving_beam(to_pos, to_pos, duration, 0)

# Creates a beam instance that elongates towards an initial target, then moves to another target
func moving_beam(init_to_pos: Vector2, end_to_pos: Vector2, init_duration: float = 0.5, moving_duration: float = 0.5) -> void:
	var new_beam = _beam_instance(init_to_pos, end_to_pos, init_duration, moving_duration)
	add_child(new_beam)
	attack_countdowns[Attacks.BEAM].append(init_duration + moving_duration)
	attack_status_changed.emit(Attacks.BEAM, true)

# Fires a single bullet that will deal impact damage around a location
func artillery_shot(to_pos: Vector2, duration: float = 2) -> void:
	var new_artillery = artillery_scene.instantiate()
	new_artillery.target_pos = to_pos
	new_artillery.duration = duration
	add_child(new_artillery)
	attack_countdowns[Attacks.ARTILLERY].append(duration)
	attack_status_changed.emit(Attacks.ARTILLERY, true)

# Creates a vine that grows between specified points
func vine(points: Array, appear_duration: float = 2, stay_duration : float = 0, disappear_duration: float = 1) -> void:
	var new_vine = vine_scene.instantiate()
	new_vine.points = points
	new_vine.appear_duration = appear_duration
	new_vine.stay_duration = stay_duration
	new_vine.disappear_duration = disappear_duration
	add_child(new_vine)
	attack_countdowns[Attacks.VINE].append(appear_duration + stay_duration + disappear_duration)
	attack_status_changed.emit(Attacks.VINE, true)

# Initiates boss jump attack towards position
func jump(to_pos: Vector2, duration: float = 3) -> void:
	animation.play("JumpAttack_START")
	jumping = true
	jump_end_anim = false
	move_target = to_pos
	move_duration = duration
	attack_status_changed.emit(Attacks.JUMP, true)

# Initiates boss dash attack towards position
func dash(to_pos: Vector2, duration: float = 0.5) -> void:
	#animation.play("Walk")
	dashing = true
	move_target = to_pos
	move_duration = duration
	move_speed = global_position.distance_to(to_pos) / duration
	attack_status_changed.emit(Attacks.DASH, true)

# Makes boss vulnerable for specified duration
func turn_vulnerable(duration: float = 5) -> void:
	dmg_zone.monitoring = false
	animation.play("Vulnerable_INITIATE")
	vulnerable_status_changed.emit(true)
	vulnerable = true
	vulnerable_duration = duration

# Destroys obstacle with specified index
func destroy(obstacle_index: int) -> void:
	destroy_obstacle.emit(obstacle_index)

# Starts/stops camera shake
func camera_shake(active : bool = true) -> void:
	set_shake.emit(active)

# Creates a wider beam that directly aims at the player. It is only visual but deals no damage
func _death_ray() -> void:
	var new_beam = _beam_instance(player.global_position, player.global_position, 0.01, 3)
	add_child(new_beam)
	new_beam.enabled = false
	new_beam.texture.scale = Vector2(2, 2)

# Creates a projectile instance and fires it
func _add_projectile(global_pos_to: Vector2, silent: bool = false) -> void:
	var projectile = projectile_scene.instantiate()
	projectile.target_pos = global_pos_to
	projectile.silent = silent
	add_child(projectile)

# Adds a salvo to salvos array
func _create_salvo(from_pos: Vector2, to_pos: Vector2, amount: int, duration: float) -> void:
	var projectiles : Array[Vector2] = []
	var offset = to_pos - from_pos
	for i in range(0, amount):
		var target_pos_x = from_pos.x + (offset.x / amount) * i
		var target_pos_y = from_pos.y + (offset.y / amount) * i
		projectiles.append(Vector2(target_pos_x, target_pos_y))
		
	salvos.append({
	"targets": projectiles,
	"shot": 0,
	"interval": duration / amount,
	"countdown": 0
	})
	attack_status_changed.emit(Attacks.SALVO, true)

# Returns a pre-configured beam instance
func _beam_instance(init_to_pos: Vector2, end_to_pos: Vector2, init_duration: float = 0.5, moving_duration: float = 0.5) -> BeamAttack:
	var new_beam = beam_scene.instantiate()
	new_beam.init_target_pos = init_to_pos
	new_beam.init_duration = init_duration
	new_beam.end_target_pos = end_to_pos
	new_beam.move_duration = moving_duration
	return new_beam

# Marks array elements for deletion. Useful so that they can be deleted during iteration
func mark_for_deletion(array: Array, index: int) -> void:
	var offset = 0
	
	# Examine all deletions that will occur before the current one
	for i in range(0, array_delete_queue.size()):
		var deletion = array_delete_queue[i]
		
		# If a deletion in the same array would affect its index
		if deletion["array"] == array and deletion["index"] < index:
			offset -= 1
			
	array_delete_queue.append({"array": array, "index": index + offset})


func _on_game_over() -> void:
	game_over = true
	timeline.pause()
	animation.clear_queue()
	animation.play("PlayerHasDied")
	player_died.emit()
	

func _on_intro_done() -> void:
	intro_over = true
	timeline.play("salvos_1")


func _on_damage_zone_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_hit.emit()

func _on_player_boss_hit() -> void:
	if vulnerable and not dmg_taken:
		dmg_taken = true
		health -= 1
		
		vulnerable_status_changed.emit(false)
		animation.play("RESET")
		animation.play("TakeDamageINITIATE")
		ControllerHandler.vibrate(0, 1, 0.5)
