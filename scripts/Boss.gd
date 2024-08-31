extends StaticBody2D

@onready var timeline = $AttackTimeline

var projectile_scene = preload("res://scenes/objects/projectile.tscn")
var beam_scene = preload("res://scenes/objects/beam_attack.tscn")

var salvos = {}
var salvo_id = 0

var game_over = false
var intro_over = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
var a = true
func queuetest():
	if a:
		for i in range(50):
			$SpriteAnimation/AnimationPlayer.queue("MockIntense")
			$SpriteAnimation/AnimationPlayer.queue("MockShort")
			$SpriteAnimation/AnimationPlayer.queue("MockIntense")
			$SpriteAnimation/AnimationPlayer.queue("MockShort")
			$SpriteAnimation/AnimationPlayer.queue("TakeDamage")
			$SpriteAnimation/AnimationPlayer.queue("MockShort")
			$SpriteAnimation/AnimationPlayer.queue("TakeDamage")
			$SpriteAnimation/AnimationPlayer.queue("TakeDamage")
			$SpriteAnimation/AnimationPlayer.queue("TakeDamage")
		a = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if intro_over and not game_over:
		queuetest()
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
					add_projectile(salvos[key]["targets"][shot_nr])
					salvos[key]["shot"] += 1
			else:
				# Delete salvo to free up ressources
				salvos.erase(key)

# Enqueues a salvo to fire
func salvo(from_pos: Vector2, to_pos: Vector2, amount: int = 20, duration: float = 4) -> void:
	create_salvo(from_pos, to_pos, amount, duration)

func machine_gun(to_pos: Vector2, amount: int = 20, duration: float = 2) -> void:
	create_salvo(to_pos, to_pos, amount, duration)

# Creates a projectile instance and fires it
func beam(to_pos: Vector2, duration: float = 0.5) -> void:
	var new_beam = beam_scene.instantiate()
	new_beam.target_pos = to_pos
	new_beam.duration = duration
	add_child(new_beam)

# Creates a projectile instance and fires it
func add_projectile(global_pos_to: Vector2) -> void:
	var projectile = projectile_scene.instantiate()
	projectile.target_pos = global_pos_to
	add_child(projectile)

# Adds a salvo to salvos array
func create_salvo(from_pos: Vector2, to_pos: Vector2, amount: int, duration: float) -> void:
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


func _on_game_over() -> void:
	game_over = true
	timeline.pause()


func _on_intro_done() -> void:
	intro_over = true
	timeline.play("salvos_1")
