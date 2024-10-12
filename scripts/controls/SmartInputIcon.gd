@tool
extends Node2D

@export var keyboard : Texture2D
@export var touch : Texture2D
@export var playstation : Texture2D
@export var xbox : Texture2D
@export var nintendo : Texture2D

@onready var sprite = $Sprite2D
var textures : Dictionary
var base_width : float = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_texture_dict()
	
	if not Engine.is_editor_hint():
		ControllerHandler.input_type_changed.connect(_on_input_type_changed)
		_on_input_type_changed(ControllerHandler.type)

func update_texture_dict() -> void:
	# Match textures to input types
	textures = {
		ControllerHandler.Type.KEYBOARD: keyboard,
		ControllerHandler.Type.TOUCH: touch,
		ControllerHandler.Type.PLAYSTATION: playstation,
		ControllerHandler.Type.XBOX: xbox,
		ControllerHandler.Type.NINTENDO: nintendo,
		ControllerHandler.Type.UNKNOWN: playstation
	}

func _on_input_type_changed(type: ControllerHandler.Type) -> void:
	sprite.texture = textures[type]
	
	# Force sprite to scale textures to the same basic size
	sprite.scale.x = base_width / float(textures[type].get_width())
	sprite.scale.y = base_width / float(textures[type].get_width())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		# Show keyboard icon as preview in editor
		update_texture_dict()
		_on_input_type_changed(ControllerHandler.Type.KEYBOARD)
