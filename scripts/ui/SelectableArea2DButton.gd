extends SelectableButton
class_name SelectableArea2DButton

@export var auto_collider : bool = true
@export var trigger_through_cancel : bool = false

@onready var sprite = $AnimatedSprite2D
@onready var label = $Label
@onready var click_sfx = $ClickSFX
@onready var collider = $Area2DButtonSrc/CollisionShape2D

var prev_visible : bool = false
var prev_scale : Vector2 = global_scale
var require_release : bool = true

signal clicked


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if auto_collider:
		collider.shape = RectangleShape2D.new()
		collider.shape.size = sprite.sprite_frames.get_frame_texture("default", 0).get_size() * sprite.scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# If the button was just shown or resized
	if is_visible_in_tree() != prev_visible or global_scale != prev_scale:
		# Require input to be released before it can be clicked
		require_release = true
		prev_visible = is_visible_in_tree()
		prev_scale = global_scale 
	
	# Poll for behavior
	super._process(delta)
	
	# If no button click input is pressed, a release has been performed
	if not Input.is_action_pressed("ui_click") and not Input.is_action_pressed("ui_select"):
		require_release = false
		
	# If button is triggerable through a "cancel" action and cancel occurs
	if trigger_through_cancel and Input.is_action_just_pressed("ui_cancel") and is_visible_in_tree() and not disabled:
		click_action()

func selection_behavior(_delta: float) -> void:
	modulate = Color(selected_color)
	sprite.frame = 1
		
	if ((Input.is_action_just_pressed("ui_click") and is_mouse_selected()) or Input.is_action_just_pressed("ui_select")) and not require_release:
		click_action()

func default_behavior(_delta: float) -> void:
	modulate = Color(default_color)
	sprite.frame = 0


func click_action():
	clicked.emit()
	click_sfx.play()
	ControllerHandler.touch_haptic_feedback()
