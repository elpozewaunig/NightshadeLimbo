extends Label

var appear = false
var game_over = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if appear:
		show()
		modulate.a += delta * 2
		if modulate.a >= 1:
			modulate.a = 1
	else:
		modulate.a -= delta * 2
		if modulate.a <= 0:
			modulate.a = 0
			hide()
			
	if game_over:
		hide()


func _on_boss_vulnerable_status_changed(vulnerable: bool) -> void:
	appear = vulnerable
	modulate.a = 0

func _on_game_over() -> void:
	game_over = true
