extends Node2D

var hearts : Array[Sprite2D] = []

var placement_pos_x = 0

@export var src_node : Node2D
@export var heart_texture : Texture2D
@export var no_heart_texture : Texture2D
@export var heart_scale : float = 1.0
@export var spacing : int

@onready var box = $Box

var max_health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_health = src_node.health
	placement_pos_x = - max_health * spacing / 2
	
	for i in range(0, max_health):
		var heart = Sprite2D.new()
		heart.scale.x = heart_scale
		heart.scale.y = heart_scale
		heart.texture = heart_texture
		
		heart.position.x = placement_pos_x
		placement_pos_x += spacing
		
		hearts.append(heart)
		add_child(heart)
	
	box.scale.x = (hearts.size() * spacing + 0.5 * heart_texture.get_width() * heart_scale) / box.texture.get_width()
	box.position.x = -spacing / 2
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in range(0, hearts.size()):
		if i < src_node.health:
			hearts[i].texture = heart_texture
		else:
			hearts[i].texture = no_heart_texture
