extends Area2D
class_name Area2DButtonSrc

@export var trigger_through_cancel = false

@onready var selector = get_parent()

@onready var sprite = $AnimatedSprite2D
@onready var label = $Label
@onready var click_sfx = $ClickSFX

var prev_visible = false
var require_release = true

signal clicked

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	# If the button was just shown, require input to be released before it can be clicked
	if is_visible_in_tree() != prev_visible:
		require_release = true
		prev_visible = is_visible_in_tree()
	
	# If the button is selected (either through the mouse or key input)
	if is_visible_in_tree() and selector.is_selected() and not selector.disabled:
		modulate = Color("ff7070")
		sprite.frame = 1
		
		if Input.is_action_just_pressed("ui_click") or Input.is_action_just_pressed("ui_select") and not require_release:
			click_action()
			
	# Button is not selected
	else:
		modulate = Color("ffffff")
		sprite.frame = 0
	
	# If no button click input is pressed, a release has been performed
	if not Input.is_action_pressed("ui_click") and not Input.is_action_pressed("ui_select"):
		require_release = false
		
	# If button is triggerable through a "cancel" action and cancel occurs
	if trigger_through_cancel and Input.is_action_just_pressed("ui_cancel") and is_visible_in_tree() and not selector.disabled:
		click_action()

func click_action():
	clicked.emit()
	click_sfx.play()
