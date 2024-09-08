extends Sprite2D

@onready var unlock_sfx = $UnlockSFX
@onready var exit = $Exit
@onready var door_obstacle = $DoorObstacle

func _ready() -> void:
	door_obstacle.process_mode = Node.PROCESS_MODE_DISABLED

func _on_boss_death_done() -> void:
	show()
	unlock_sfx.play()
	door_obstacle.process_mode = Node.PROCESS_MODE_INHERIT
	exit.monitoring = true
