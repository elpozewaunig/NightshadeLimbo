extends Node2D

@export var keyboard : Texture2D
@export var touch : Texture2D
@export var playstation : Texture2D
@export var xbox : Texture2D
@export var nintendo : Texture2D

@onready var sprite = $Sprite2D
var textures : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	textures = {
		ControllerHandler.Type.KEYBOARD: keyboard,
		ControllerHandler.Type.TOUCH: touch,
		ControllerHandler.Type.PLAYSTATION: playstation,
		ControllerHandler.Type.XBOX: xbox,
		ControllerHandler.Type.NINTENDO: nintendo,
		ControllerHandler.Type.UNKNOWN: keyboard
	}
	ControllerHandler.input_method_changed.connect(_on_input_method_changed)
	_on_input_method_changed(ControllerHandler.type)

func _on_input_method_changed(type: ControllerHandler.Type) -> void:
	sprite.texture = textures[type]
