extends HSlider
class_name SliderButtonSrc

@onready var selector = get_parent()

var slider_speed : float = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# If the button is selected (either through the mouse or key input)
	if is_visible_in_tree() and selector.is_selected() and not selector.disabled:
		modulate = Color("ff7070")
		
		if Input.is_action_pressed("ui_left"):
			value -= delta * slider_speed
		if Input.is_action_pressed("ui_right"):
			value += delta * slider_speed
			
	# Button is not selected
	else:
		modulate = Color("ffffff")
