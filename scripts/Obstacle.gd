extends StaticBody2D

@onready var sprite = $Sprite2D
@onready var collider = $CollisionShape2D

func _ready() -> void:
	sprite.frame = 0

func destroy() -> void:
	sprite.frame = 1
	collider.set_deferred("disabled", true)
