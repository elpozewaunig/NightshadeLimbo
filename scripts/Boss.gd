extends StaticBody2D

@onready var timeline = $AttackTimeline
@onready var animation = $Tomato/AnimationPlayer
@onready var dmg_zone = $DamageZone

var projectile_scene = preload("res://scenes/boss_attacks/projectile.tscn")
var beam_scene = preload("res://scenes/boss_attacks/beam_attack.tscn")
var artillery_scene = preload("res://scenes/boss_attacks/artillery_projectile.tscn")
var vine_scene = preload("res://scenes/boss_attacks/vine_attack.tscn")
var impact_scene = preload("res://scenes/boss_attacks/jump_impact.tscn")

@export var health : int = 3
var vulnerable = false
var vulnerable_duration = 0
var dmg_taken = false

# Stores necessary data for firing bullets
var salvos = []

# Stores simple countdown for each attack to trigger actions upon completion
var beams : Array[float] = []
var artillery : Array[float] = []
var vines : Array[float] = []

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
			# If the salvo isn't completed yet
			if shot_nr < salvo_targets.size():
				# Reduce the salvo's countdown until the next shot
				next_salvos[i]["countdown"] -= delta
				
				if next_salvos[i]["countdown"] <= 0:
					# Reset countdown for next projectile
					next_salvos[i]["countdown"] = next_salvos[i]["interval"]
					
					# Fire the next projectile in the salvo
					_add_projectile(next_salvos[i]["targets"][shot_nr])
					next_salvos[i]["shot"] += 1
			else:
				# Delete salvo to free up ressources
				mark_for_deletion(salvos, i)
		
		# Iterate through all beams and count down their remaining time
		for i in range(0, beams.size()):
			beams[i] -= delta
			# Remove expired beams
			if beams[i] <= 0:
				mark_for_deletion(beams, i)
		
		# Iterate through all artillery projectiles and count down their remaining time
		for i in range(0, artillery.size()):
			artillery[i] -= delta
			# Remove expired artillery projectiles
			if artillery[i] <= 0:
				mark_for_deletion(artillery, i)
		
		# Iterate through all vines and count down their remaining time
		for i in range(0, vines.size()):
			vines[i] -= delta
			# Remove expired beams
			if vines[i] <= 0:
				mark_for_deletion(vines, i)
		
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
				attack_status_changed.emit("jump", false)
		
		# Handle dashing
		if dashing:
			move_duration -= delta
			global_position = global_position.move_toward(move_target, move_speed * delta)
			
			if move_duration <= 0:
				global_position = move_target
				dashing = false
				attack_status_changed.emit("dash", false)
		
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
		
	# Delete all array entries that were marked for deletion
	for deletion in array_delete_queue:
		deletion["array"].remove_at(deletion["index"])
	array_delete_queue.clear()
	
	# Emit status signals for attacks that have stopped 
	if salvos.is_empty():
		attack_status_changed.emit("salvo", false)
	
	if beams.is_empty():
		attack_status_changed.emit("beam", false)
	
	if artillery.is_empty():
		attack_status_changed.emit("artillery", false)
	
	if vines.is_empty():
		attack_status_changed.emit("vine", false)


# Enqueues a salvo to fire
func salvo(from_pos: Vector2, to_pos: Vector2, amount: int = 20, duration: float = 4) -> void:
	_create_salvo(from_pos, to_pos, amount, duration)

func machine_gun(to_pos: Vector2, amount: int = 20, duration: float = 2) -> void:
	_create_salvo(to_pos, to_pos, amount, duration)

# Creates a beam instance and fires it
func beam(to_pos: Vector2, duration: float = 0.5) -> void:
	moving_beam(to_pos, to_pos, duration, 0)

func moving_beam(init_to_pos: Vector2, end_to_pos: Vector2, init_duration: float = 0.5, moving_duration: float = 0.5) -> void:
	var new_beam = beam_scene.instantiate()
	new_beam.init_target_pos = init_to_pos
	new_beam.init_duration = init_duration
	new_beam.end_target_pos = end_to_pos
	new_beam.move_duration = moving_duration
	add_child(new_beam)
	beams.append(init_duration + moving_duration)
	attack_status_changed.emit("beam", true)

func artillery_shot(to_pos: Vector2, duration: float = 2) -> void:
	var new_artillery = artillery_scene.instantiate()
	new_artillery.target_pos = to_pos
	new_artillery.duration = duration
	add_child(new_artillery)
	artillery.append(duration)
	attack_status_changed.emit("artillery", true)

func vine(points: Array, duration: float = 2, disappear_duration: float = 1) -> void:
	var new_vine = vine_scene.instantiate()
	new_vine.points = points
	new_vine.duration = duration
	new_vine.disappear_duration = disappear_duration
	add_child(new_vine)
	vines.append(duration + disappear_duration)
	attack_status_changed.emit("vine", true)

func jump(to_pos: Vector2, duration: float = 3) -> void:
	animation.play("JumpAttack_START")
	jumping = true
	jump_end_anim = false
	move_target = to_pos
	move_duration = duration
	attack_status_changed.emit("jump", true)

func dash(to_pos: Vector2, duration: float = 0.5) -> void:
	#animation.play("Walk")
	dashing = true
	move_target = to_pos
	move_duration = duration
	move_speed = global_position.distance_to(to_pos) / duration
	attack_status_changed.emit("dash", true)

func turn_vulnerable(duration: float = 5) -> void:
	dmg_zone.monitoring = false
	animation.play("Vulnerable_INITIATE")
	vulnerable_status_changed.emit(true)
	vulnerable = true
	vulnerable_duration = duration

func destroy(obstacle_index: int) -> void:
	destroy_obstacle.emit(obstacle_index)

func camera_shake(active : bool = true) -> void:
	set_shake.emit(active)

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
	attack_status_changed.emit("salvo", true)

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
