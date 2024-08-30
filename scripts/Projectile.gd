extends Area2D
class_name Projectile

signal player_hit

var target_pos : Vector2 = Vector2(0, 0)
var speed : int = 800
var offset : Vector2
var length : float
var total_progress : float = 0

@onready var collider = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	offset = target_pos - global_position
	length = sqrt(pow(offset.x, 2) + pow(offset.y, 2))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if collider.disabled:
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
		collider.set_deferred("disabled", true)


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not collider.disabled:
		player_hit.connect(body._on_projectile_hit)
		collider.set_deferred("disabled", true)
