extends Area2D

var segment = preload("res://scenes/boss_attacks/vine_segment.tscn")
var current_segments : Array[VineSegment] = []
var current_segment = 0

var points : Array[Vector2] = [Vector2(960, 540), Vector2(1920, 540)]
var duration: float = 2

var current_pos : Vector2
var total_distance : float = 0
var individual_distances : Array[float] = []
var speed : float

signal player_hit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var last_point = global_position
	# Calculate the total and individual distances between segments
	for point in points:
		total_distance += last_point.distance_to(point)
		last_point = point
		
	speed = total_distance / duration

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if current_segments.is_empty() or current_segments[current_segment].done:
		# If not all points already have segments pointing towards them
		if not current_segments.size() == points.size():
			if not current_segments.is_empty():
				current_segment += 1
			
			var next_segment = segment.instantiate()
			
			next_segment.from_pos = current_pos
			next_segment.target_pos = points[current_segment]
			next_segment.speed = speed
			current_segments.append(next_segment)
			add_child(next_segment)
			
			# The position that the next segment will start from is the current vine's target
			current_pos = points[current_segment]
			
		else:
			pass
			#queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_hit.connect(body._on_vine_hit)
		emit_signal("player_hit")
