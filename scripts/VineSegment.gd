extends CollisionShape2D
class_name VineSegment

@onready var texture = $Texture
@onready var gapfill = $GapFill

var from_pos : Vector2 = Vector2(0, 0)
var target_pos : Vector2 = Vector2(960, 540)
var speed : float = 800
var reverse_speed: float = 1000

var offset : Vector2
var length : float = 0
var distance : float

var reverse : bool = false

var done : bool = false
var reversed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Create new shape so that properties are independent
	shape = RectangleShape2D.new()
	shape.size.x = 55
	
	global_position = from_pos
	
	# Rotate towards target, -90 because vine is pointing downwards
	look_at(target_pos)
	rotation_degrees -= 90
	
	offset = target_pos - from_pos
	distance = global_position.distance_to(target_pos)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Grow segment
	if not done and not reverse:
		# Consistently increase length of segment
		length += delta * speed
		
		# Target reached
		if length >= distance:
			length = distance
			done = true

	# Retract segment
	if reverse and not reversed:
		length -= delta * reverse_speed
		
		if length <= 0:
			length = 0
			reversed = true
	
	# Calculate percentage of growth
	var progress = length / distance
		
	# Reposition correctly
	global_position.x = from_pos.x + (offset.x * progress) / 2
	global_position.y = from_pos.y + (offset.y * progress) / 2
	gapfill.global_position = from_pos
	
	# Always make the texture and collider match the specified dimensions
	texture.region_rect = Rect2(0, 0, 250, length / texture.scale.y)
	shape.size.y = length
