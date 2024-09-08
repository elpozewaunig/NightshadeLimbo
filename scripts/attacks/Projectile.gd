extends Area2D

signal player_hit

@onready var sfx = $AudioStreamPlayer

var target_pos : Vector2 = Vector2(0, 0)
var silent : bool = false
var speed : int = 800
var offset : Vector2
var length : float
var total_progress : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	offset = target_pos - global_position
	length = sqrt(pow(offset.x, 2) + pow(offset.y, 2))
	
	# Rotate projectile correctly
	look_at(target_pos)
	
	if silent:
		sfx.autoplay = false
		sfx.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not monitoring:
		# Make projectile fade out
		modulate.a -= 2 * delta
		if modulate.a <= 0:
			hide()
			queue_free()
		
	else:
		# Calculate how much of the total distance is covered in the current frame
		var progress = delta * speed / length
		total_progress += progress
		
		# Move projectile towards target according to calculated progress
		global_position.x += offset.x * progress
		global_position.y += offset.y * progress
	
	if total_progress >= 1:
		global_position = target_pos
		monitoring = false


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not body.dead:
		player_hit.connect(body._on_projectile_hit)
		player_hit.emit()
	elif body.get_class() == "StaticBody2D" and not body.name == "Boss":
		# Stop projectile by telling it it has reached its target
		total_progress = 1
		target_pos = global_position
		set_deferred("monitoring", false)
