extends Area2D

@onready var impact_sprite = $ImpactSprite
@onready var impact_sfx = $ImpactSFX
@onready var collider = $CollisionShape2D
@onready var projectile = $Projectile

var target_pos : Vector2 = Vector2(960, 540)
var duration : float = 2

var time_elapsed : float = 0
var speed : float = 1500
var ascending : bool = true
var descending : bool = false
var target_reached : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation_degrees = 180
	impact_sprite.hide()
	monitorable = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	duration -= delta
	
	# Rapidly move upwards
	if ascending:
		position.y -= speed * delta
		if position.y < -200:
			ascending = false
			global_position.x = target_pos.x
			global_position.y = 0
			modulate.a = 0
	
	# Move downwards when it is time
	if duration <= abs(target_pos.y - global_position.y) / speed:
		descending = true
		rotation_degrees = 0
		modulate.a = 1
	
	# While the projectile hasn't reached its target yet
	if descending and duration > 0:
		position.y += speed * delta
	
	# First frame of target reached
	if duration <= 0 and not target_reached:
		global_position = target_pos
		monitorable = true
		impact_sprite.show()
		impact_sfx.play()
		target_reached = true
		
	if target_reached:
		# Make projectile disappear quickly
		projectile.modulate.a -= delta * 3
		if projectile.modulate.a <= 0:
			projectile.modulate.a = 0
		
		# Make impact disappear more slowly
		impact_sprite.modulate.a -= delta
		if impact_sprite.modulate.a <= 0:
			impact_sprite.modulate.a = 0
			monitorable = false
			queue_free()
