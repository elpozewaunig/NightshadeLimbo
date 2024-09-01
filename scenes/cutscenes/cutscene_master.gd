extends Node2D

signal NEXT
@export var scenes: Array[PackedScene] = []

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	NEXT.connect(changeScene)
	changeScene()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var sceneIndex = 0
var todelete = null

func changeScene():
	print("CHANGEW!")
	if todelete != null:
		remove_child(todelete)
	todelete = scenes[sceneIndex].instantiate()
	add_child(todelete)
	sceneIndex += 1
