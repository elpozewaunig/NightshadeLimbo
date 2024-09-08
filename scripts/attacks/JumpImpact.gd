extends Area2D

var lifetime = 0.5

signal player_hit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lifetime -= delta
	modulate.a = lifetime
	if lifetime < 0:
		hide()
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not body.dead:
		player_hit.connect(body._on_impact_hit)
		player_hit.emit()
