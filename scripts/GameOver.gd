extends Node2D

@onready var label = $Label

var music = AmbienceMusic
var game_scene = preload("res://scenes/main.tscn")

var game_over = false
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
	"The Nightshades know no mercy!",
	"You failed.",
	"Keep failing - it is futile",
	"You were doomed from the start."
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
		get_tree().change_scene_to_packed(game_scene)


func _on_game_over() -> void:
	game_over = true
	music.reset_volume()
	music.play()
	label.text = messages[randi() % messages.size()]
	
