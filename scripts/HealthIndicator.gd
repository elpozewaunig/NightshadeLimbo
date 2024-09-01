extends Node2D

var heart_scene = preload("res://scenes/reusable/heart.tscn")
var hearts : Array[Sprite2D] = []

var placement_pos_x = 0

@export var src_node : Node2D
@export var spacing : int

var max_health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_health = src_node.health
	
	for i in range(0, max_health):
		var heart = heart_scene.instantiate()
		heart.position.x = placement_pos_x
		placement_pos_x += spacing
		
		hearts.append(heart)
		add_child(heart)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in range(0, hearts.size()):
		if i < src_node.health:
			hearts[i].visible = true
		else:
			hearts[i].visible = false
