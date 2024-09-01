extends StaticBody2D

@onready var sprite = $AnimatedSprite2D
@onready var collider = $CollisionShape2D
@onready var occluder = $LightOccluder2D

func _ready() -> void:
	sprite.frame = 0

func destroy() -> void:
	sprite.frame = 1
	occluder.hide()
	collider.set_deferred("disabled", true)
