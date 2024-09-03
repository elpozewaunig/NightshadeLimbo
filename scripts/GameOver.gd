extends Node2D

@onready var label = $Label

var music = AmbienceMusic

var game_over = false
var chance_missed = false
var time_elapsed = 0
var messages = [
	"Failure was inevitable.",
	"You're not done yet.",
	"This is your own personal kind of hell.",
	"Has that glimmer of hope still not died?",
	"You'll fail again.",
	"You're stuck here forever.",
	"Failure won't save you.",
	"Over and over again.",
	"Again.",
	"The Nightshades know no mercy.",
	"You failed.",
	"Keep failing - it is futile.",
	"You were doomed from the start.",
	"Your failure was only a matter of time."
	]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = 0
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_over:
		show()
		time_elapsed += delta
		modulate.a += delta * 0.5
		if modulate.a >= 1:
			modulate.a = 1
	
	if time_elapsed > 5:
		SceneManager.change_scene(SceneManager.game_scene)


func _on_game_over() -> void:
	game_over = true
	music.reset_volume()
	music.play()
	if chance_missed:
		label.text = "You missed your chance."
	else:
		label.text = messages[randi() % messages.size()]

func _on_chance_missed() -> void:
	chance_missed = true
