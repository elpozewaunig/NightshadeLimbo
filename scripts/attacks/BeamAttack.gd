extends Area2D

@onready var collider = $CollisionShape2D
@onready var texture = $CollisionShape2D/Texture
@onready var particles = $Particles
@onready var sfx = $AudioStreamPlayer

@export var width = 20
@export var animation_fps = 10

var length = 0
var length_created = 0
var distance_travelled = 0

var length_override : bool = false
var force_length : float

var init_target_pos : Vector2 = Vector2(960, 1080)
var init_duration : float = 1
var end_target_pos : Vector2 = Vector2(1920, 1080)
var move_duration : float = 1

var speed_to_init : float
var distance_to_init : float

var move_speed : float
var distance_to_move : float

var init_target_reached : bool = false
var end_target_reached : bool = false
var time_elapsed : float = 0

var bodies_hit : Array[StaticBody2D] = []

signal player_hit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect to signal from boss
	get_parent().player_died.connect(_on_player_died)
	
	# Create new shape so that properties are independent
	collider.shape = RectangleShape2D.new()
	collider.shape.size.x = width
	
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
func _process(delta: float) -> void:
	
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
		
		# If no obstacle is in the way
		if not length_override:
			# Assume ideal length
			length = length_created
			if length >= distance_to_init:
				length = distance_to_init
				init_target_reached = true
			
		# Obstacle is in the way
		else:
			# Assume length enforced by obstacle
			length = force_length
			
			# If the beam has a secondary target, immediately start movement
			if move_duration > 0:
				init_target_reached = true
			
			# Else wait until the beam would have reached its initial target
			elif length_created >= distance_to_init:
				init_target_reached = true
		
	# Moving beam towards end target
	elif not end_target_reached and distance_travelled < distance_to_move:
		distance_travelled += delta * move_speed
		
		# Calculate current in-between point
		var current_pos = init_target_pos.move_toward(end_target_pos, distance_travelled)
		
		# If no obstacle is in the way
		if not length_override:
			length = global_position.distance_to(current_pos)
		else:
			length = force_length
		
		rotate_towards(current_pos)
		
	# End target reached
	elif not end_target_reached and distance_travelled >= distance_to_move:
		length = global_position.distance_to(end_target_pos)
		rotate_towards(end_target_pos)
		end_target_reached = true
	
	# Gradually make beam disappear
	if end_target_reached:
		modulate.a -= 2 * delta
		if modulate.a <= 0:
			hide()
			queue_free()
	
	grow_to_length(length)

func grow_to_length(target_length: float) -> void:
	# Reposition children according to length
	collider.position.y = target_length/2
	particles.position.y = target_length
	
	# Always make the texture and collider match the specified dimensions
	texture.region_rect = Rect2(0, 0, 250, target_length / texture.scale.y)
	collider.shape.size.y = target_length

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not body.dead:
		player_hit.connect(body._on_beam_hit)
		player_hit.emit()
		
	# When an obstacle is hit
	elif body.get_class() == "StaticBody2D" and body.is_in_group("Obstacles"):
		# Record that beam is currently colliding with body
		bodies_hit.append(body)
		
		length_override = true
		force_length = global_position.distance_to(body.global_position)
		grow_to_length(force_length)

func _on_body_exited(body: Node2D) -> void:
	if body.get_class() == "StaticBody2D" and body.is_in_group("Obstacles"):
		# Body is no longer colliding with this body
		bodies_hit.erase(body)
		
		if bodies_hit.is_empty():
			length_override = false

# Turns towards target point, applies fix due to sprite orientation
func rotate_towards(target : Vector2) -> void:
	look_at(target)
	rotation_degrees -= 90 # -90 since beam is pointing downwards

func _on_player_died():
	sfx.stop()
