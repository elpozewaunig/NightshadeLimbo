extends Node2D

@onready var label = $Background/Label
@onready var hint = $Background/Hint

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
	"Your failure was only a matter of time.",
	"It'll only get worse.",
	"You didn’t stand a chance.",
	"Too weak. Too slow.",
	"Your failure only makes me grow stronger.",
	"You haven’t learned from your mistakes.",
	"You’re lost forever.",
	"Death is a mercy I won’t grant you.",
	"Who will remember you?",
	"Failure is all that your future holds.",
	"You’ll find no pity here.",
	"An eternity of suffering.",
	"This was only the beginning.",
	"There is no escape.",
	"Your fate is sealed.",
	"You are destined to fail again.",
	"Forever is a long time. You’ll feel it.",
	"Not even close.",
	"So much agony ahead of you.",
	"The only way is down.",
	"Your effort was in vain.",
	"Your feeble attempts are all bound to fail.",
	"Survival wasn’t an option.",
	"Rinse and repeat.",
	"You’ll be broken.",
	"Beg all you want.",
	"No way out of this.",
	"A taste of the rest of your miserable existence.",
	"There’s no chance for you.",
	"Your suffering will know no limits.",
	"You’ll experience nothing but failure."
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
	
	# Show remnant mode hint on 10th death
	if Data.run_deaths == 10 and not Data.remnant_active:
		hint.show()
	else:
		hint.hide()

func _on_chance_missed() -> void:
	chance_missed = true
