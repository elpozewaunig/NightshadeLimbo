@tool
extends Node2D

@export var src_node : Node2D
@export var heart_texture : Texture2D
@export var no_heart_texture : Texture2D
@export var heart_scale : float = 1.0
@export var spacing : int

@onready var box = $Box

var max_health : int
var prev_src_node : Node2D = src_node
var prev_max_health : int

var hearts : Array[Sprite2D] = []

var placement_pos_x : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if src_node != null:
		max_health = src_node.health
	else:
		max_health = 0
	
	prev_src_node = src_node
	prev_max_health = max_health
	placement_pos_x = - max_health * spacing / 2
	
	for heart in hearts:
		remove_child(heart)
	hearts.clear()
		
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
	box.position.x = - float(spacing) / 2
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		# Update display when src node changes or health changes in editor
		if src_node != prev_src_node or (src_node != null and src_node.health != prev_max_health):
			_ready()
	
	if visible:
		for i in range(0, hearts.size()):
			if i < src_node.health:
				hearts[i].texture = heart_texture
			else:
				hearts[i].texture = no_heart_texture
