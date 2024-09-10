extends RayCast2D
class_name BeamAttack

@onready var texture = $Texture
@onready var particles = $Particles
@onready var sfx = $AudioStreamPlayer

@export var animation_fps = 10

var length = 0
var length_created = 0
var distance_travelled = 0

var init_target_pos : Vector2 = Vector2(960, 1080)
var init_duration : float = 1
var end_target_pos : Vector2 = Vector2(1920, 1080)
var move_duration : float = 1

var speed_to_init : float
var distance_to_init : float

var move_speed : float
var distance_to_move : float

var current_target_pos : Vector2
var init_target_reached : bool = false
var end_target_reached : bool = false
var time_elapsed : float = 0

var collision : bool = false
var collision_point : Vector2

signal player_hit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect to signal from boss
	get_parent().player_died.connect(_on_player_died)
	
	current_target_pos = init_target_pos
	rotate_towards(init_target_pos)
	
	# Values for making beam reach initial target
	assert(init_duration > 0)
	distance_to_init = global_position.distance_to(init_target_pos)
	speed_to_init = distance_to_init / init_duration
	
	# Values while beam moves from initial target to end target
	distance_to_move = init_target_pos.distance_to(end_target_pos)
	if move_duration > 0:
		move_speed = distance_to_move / move_duration
	else:
		move_speed = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	# Change to next frame of texture when specified time has passed
	time_elapsed += delta
	if time_elapsed >= 1 / float(animation_fps):
		# Get next frame if within bounds
		if texture.frame < texture.hframes * texture.vframes - 1:
			texture.frame += 1
		else:
			texture.frame = 0
			
		time_elapsed = 0
	
	# Beam is still moving towards initial target
	if not init_target_reached:
		# Consistently increase ideal length of beam
		length_created += delta * speed_to_init
		if length_created >= distance_to_init:
			length_created = distance_to_init
			init_target_reached = true
		
		current_target_pos = global_position.move_toward(init_target_pos, length_created)
		
	# Moving beam towards end target
	elif not end_target_reached and distance_travelled < distance_to_move:
		distance_travelled += delta * move_speed
		if distance_travelled >= distance_to_move:
			distance_travelled = distance_to_move
			end_target_reached = true
			
		current_target_pos = init_target_pos.move_toward(end_target_pos, distance_travelled)
	
	# Gradually make beam disappear while at end target
	if end_target_reached:
		modulate.a -= 2 * delta
		if modulate.a <= 0:
			hide()
			queue_free()
	
	# Set length and raycast target to ideal length
	length = global_position.distance_to(current_target_pos)
	target_position = position.move_toward(current_target_pos - global_position, length)
	if enabled:
		force_raycast_update()
	
	# Handle collisions
	var collision_object = get_collider()
	if collision_object:
		if collision_object.name == "Player" and not collision_object.dead:
			update_collision_point()
			player_hit.connect(collision_object._on_beam_hit)
			player_hit.emit()
		elif collision_object.is_in_group("Obstacles"):
			update_collision_point()
			
		# Don't handle any other collision objects	
		else:
			collision = false
	
	else:
		collision = false
	
	# Correct visual beam length if a collision occurs
	if collision:
		length = global_position.distance_to(collision_point)
		
		if not init_target_reached:
			# If the beam has a secondary target, immediately start movement
			if move_duration > 0:
				init_target_reached = true
			
			# Else wait until the beam would have reached its initial target
			elif length_created >= distance_to_init:
				init_target_reached = true
	
	# Reposition particles according to length
	particles.global_position = global_position.move_toward(current_target_pos, length)
	
	# Always make the texture match the specified dimensions and orientation
	rotate_towards(current_target_pos)
	texture.global_position = global_position.move_toward(current_target_pos, length/2)
	texture.region_rect = Rect2(0, 0, 250, length / texture.scale.y)


func update_collision_point() -> void:
	collision = true
	collision_point = get_collision_point()

# Turns towards target point, applies fix due to sprite orientation
func rotate_towards(target : Vector2) -> void:
	texture.look_at(target)
	texture.rotation_degrees -= 90 # -90 since beam is pointing downwards

func _on_player_died():
	sfx.stop()
