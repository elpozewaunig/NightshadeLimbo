extends Area2D

var segment = preload("res://scenes/boss_attacks/vine_segment.tscn")
var current_segments : Array[VineSegment] = []

var points : Array = [Vector2(960, 540), Vector2(1200, 540), Vector2(1920, 540)]
var duration: float = 2
var disappear_duration: float = 1

var current_pos : Vector2
var total_distance : float = 0
var individual_distances : Array[float] = []
var speed : float
var reverse_speed : float
var overshoot : float = 0
var pre_delete_delta : float = 0
var retracting : bool = false

signal player_hit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var last_point = global_position
	# Calculate the total distance between segments
	for point in points:
		total_distance += last_point.distance_to(point)
		last_point = point
	
	assert(duration > 0)
	assert(disappear_duration > 0)
	
	speed = total_distance / duration
	reverse_speed = total_distance / disappear_duration
	current_pos = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Growing phase
	if (current_segments.is_empty() or current_segments[-1].done) and not retracting:
		# If not all points already have segments pointing towards them
		if current_segments.size() < points.size():
			
			# Set up next segment
			var next_segment = segment.instantiate()
			next_segment.from_pos = current_pos
			next_segment.target_pos = points[current_segments.size()]
			next_segment.speed = speed
			next_segment.reverse_speed = reverse_speed
			
			# Add overshoot if previous segment exists
			if not current_segments.is_empty():
				overshoot = current_segments.back().overshoot
				
			next_segment.length = overshoot
			next_segment.compensate_delta = delta
			
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
			
			# Vine is not reversing yet
			if not vine.reversed and not vine.reverse:
				vine.reverse = true
				vine.compensate_delta = pre_delete_delta
				vine.length -= abs(overshoot)
			
			if vine.reversed:
				overshoot = vine.overshoot
				pre_delete_delta = delta
				current_segments.remove_at(current_segments.size() - 1)
				vine.queue_free()
		else:
			queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not body.dead:
		player_hit.connect(body._on_vine_hit)
		player_hit.emit()
