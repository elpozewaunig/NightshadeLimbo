extends StaticBody2D

@onready var timeline = $AttackTimeline

var projectile_scene = preload("res://scenes/objects/projectile.tscn")

var salvos = {}
var salvo_id = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timeline.play("salvos_1")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
func salvo(from_pos: Vector2, to_pos: Vector2, amount: int = 20, time_between: float = 0.1) -> void:
	salvos[salvo_id] = {
		"targets": create_salvo(from_pos, to_pos, amount),
		"shot": 0,
		"interval": time_between,
		"countdown": 0
	}
	salvo_id += 1

# Creates a projectile instance and fires it
func add_projectile(global_pos: Vector2) -> void:
	var projectile = projectile_scene.instantiate()
	projectile.target_pos = global_pos
	add_child(projectile)

# Creates an array containing positions to be fired at in that order
func create_salvo(from_pos: Vector2, to_pos: Vector2, salvo_amount: int) -> Array[Vector2]:
	var projectiles : Array[Vector2] = []
	var offset = to_pos - from_pos
	for i in range(0, salvo_amount):
		var target_pos_x = from_pos.x + (offset.x / salvo_amount) * i
		var target_pos_y = from_pos.y + (offset.y / salvo_amount) * i
		projectiles.append(Vector2(target_pos_x, target_pos_y))
	
	return projectiles
