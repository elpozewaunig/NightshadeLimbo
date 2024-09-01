extends Area2D

var segment = preload("res://scenes/boss_attacks/vine_segment.tscn")
var current_segments : Array[VineSegment] = []

var points : Array = [Vector2(960, 540), Vector2(1200, 540), Vector2(1920, 540)]
var duration: float = 2

var current_pos : Vector2
var total_distance : float = 0
var individual_distances : Array[float] = []
var speed : float
var retracting : bool = false

signal player_hit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var last_point = global_position
	# Calculate the total and individual distances between segments
	for point in points:
		total_distance += last_point.distance_to(point)
		last_point = point
		
	speed = total_distance / duration
	current_pos = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Growing phase
	if (current_segments.is_empty() or current_segments[-1].done) and not retracting:
		# If not all points already have segments pointing towards them
		if current_segments.size() < points.size():
			
			# Set up next segment
			var next_segment = segment.instantiate()
			next_segment.from_pos = current_pos
			next_segment.target_pos = points[current_segments.size()]
			next_segment.speed = speed
			add_child(next_segment)
			current_segments.append(next_segment)
			
			# The position that the next segment will start from is the current vine's target
			current_pos = next_segment.target_pos
		
		# Vine has fully expanded, retract
		else:
			monitorable = false
			retracting = true
	
	# Retracting phase
	if retracting:
		if not current_segments.is_empty():
			var vine = current_segments[-1]
			vine.reverse = true
			
			# If the segment reports that it has completely retracted
			# Remove it and repeat with the next segment
			if vine.reversed:
				current_segments.remove_at(current_segments.size() - 1)
				vine.queue_free()
		else:
			queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_hit.connect(body._on_vine_hit)
		emit_signal("player_hit")
