extends Area2D

@onready var collider = $CollisionShape2D
@onready var texture = $CollisionShape2D/Texture
@onready var particles = $Particles

@export var width = 20
@export var animation_fps = 5
var length = 0

var target_pos : Vector2 = Vector2(960, 1080)
var duration : float = 1

var speed : float
var distance : float
var time_elapsed : float = 0

signal player_hit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set collider to specified width
	collider.shape.size.x = width
	
	# Rotate towards target, -90 because beam is pointing downwards
	look_at(target_pos)
	rotation_degrees -= 90
	
	distance = global_position.distance_to(target_pos)
	speed = distance / duration

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Change to next frame of texture when specified time has passed
	time_elapsed += delta
	if time_elapsed >= 1 / animation_fps:
		# Get next frame if within bounds
		if texture.frame < texture.hframes * texture.vframes - 1:
			texture.frame += 1
		else:
			texture.frame = 0
			
		time_elapsed = 0
	
	# Target reached
	if length >= distance:
		modulate.a -= 2 * delta
		if modulate.a <= 0:
			hide()
			queue_free()
	else:
		# Consistently increase length of beam
		length += delta * speed
		
		# Reposition children accordingly
		collider.position.y = length/2
		particles.position.y = length
		
		
		# Always make the texture and collider match the specified dimensions
		texture.region_rect = Rect2(0, 0, 250, length / texture.scale.y)
		collider.shape.size.y = length

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not collider.disabled:
		player_hit.connect(body._on_beam_hit)
		emit_signal("player_hit")
		collider.set_deferred("disabled", true)
