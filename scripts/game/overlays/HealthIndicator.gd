@tool
extends Node2D

@export var src_node : Node2D
@export var heart_texture : Texture2D
@export var no_heart_texture : Texture2D
@export var heart_scale : float = 1.0
@export var heart_spacing : float
@export var box_padding : Vector2

@onready var box = $Box

var prev_src_node : Node2D = src_node
var prev_heart_texture : Texture2D = heart_texture
var prev_heart_scale : float = heart_scale
var prev_heart_spacing : float = heart_spacing
var prev_box_padding : Vector2 = box_padding

var max_health : int
var prev_max_health : int

var hearts : Array[Sprite2D] = []

var placement_pos_x : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if src_node != null:
		max_health = src_node.health
	else:
		max_health = 0
	
	# Sync change detector variables
	prev_src_node = src_node
	prev_heart_texture = heart_texture
	prev_max_health = max_health
	prev_heart_scale = heart_scale
	prev_heart_spacing = heart_spacing
	prev_box_padding = box_padding
	
	var effective_spacing : float = heart_spacing + heart_texture.get_width() * heart_scale
	placement_pos_x = - (max_health * effective_spacing - heart_spacing) / 2
	
	for heart in hearts:
		remove_child(heart)
	hearts.clear()
		
	for i in range(0, max_health):
		var heart = Sprite2D.new()
		heart.scale = Vector2(heart_scale, heart_scale)
		
		heart.position.x = placement_pos_x
		placement_pos_x += effective_spacing
		
		hearts.append(heart)
		add_child(heart)
	
	box.scale.x = (hearts.size() * effective_spacing - heart_spacing + 2 * box_padding.x) / box.texture.get_width()
	box.scale.y = (heart_texture.get_height() * heart_scale + 2 * box_padding.y) / box.texture.get_height()
	box.position.x = - float(effective_spacing) / 2
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		# Update display when properties change or src_node's health changes in editor
		if (src_node != prev_src_node or (src_node != null and src_node.health != prev_max_health)
		or heart_scale != prev_heart_scale or heart_spacing != prev_heart_spacing
		or box_padding != prev_box_padding or heart_texture != prev_heart_texture):
			_ready()
	
	if visible:
		for i in range(0, hearts.size()):
			if i < src_node.health:
				hearts[i].texture = heart_texture
			else:
				hearts[i].texture = no_heart_texture
