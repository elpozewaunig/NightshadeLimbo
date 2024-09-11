extends Node2D

@export var keyboard : Texture2D
@export var playstation : Texture2D
@export var xbox : Texture2D
@export var nintendo : Texture2D

@onready var sprite = $Sprite2D
var textures : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	textures = {
		ControllerDetector.Type.KEYBOARD: keyboard,
		ControllerDetector.Type.PLAYSTATION: playstation,
		ControllerDetector.Type.XBOX: xbox,
		ControllerDetector.Type.NINTENDO: nintendo
	}
	ControllerDetector.input_method_changed.connect(_on_input_method_changed)
	_on_input_method_changed(ControllerDetector.type)

func _on_input_method_changed(type: ControllerDetector.Type) -> void:
	sprite.texture = textures[type]
