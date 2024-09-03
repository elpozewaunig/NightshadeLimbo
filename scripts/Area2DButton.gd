extends Area2D
class_name Area2DButton

@onready var sprite = $AnimatedSprite2D
@onready var label = $Label
@onready var click_sfx = $ClickSFX
@onready var select_sfx = $SelectSFX

var mouse_inside = false
var disabled = false
var highlight_active = false
var ext_selected = false
var prev_visible = false
var require_release = true

signal clicked
signal selected(button)

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
	if is_visible_in_tree() and ((mouse_inside and not highlight_active) or (ext_selected and highlight_active)) and not disabled:
		modulate = Color("ff7070")
		sprite.frame = 1
		
		if Input.is_action_just_pressed("ui_click") or Input.is_action_just_pressed("ui_select") and not require_release:
			emit_signal("clicked")
			click_sfx.play()
			
	# Button is not selected
	else:
		modulate = Color("ffffff")
		sprite.frame = 0
	
	# If no button click input is pressed, a release has been performed
	if not Input.is_action_pressed("ui_click") and not Input.is_action_pressed("ui_select"):
		require_release = false


func _on_mouse_entered() -> void:
	if is_visible_in_tree() and not disabled:
		mouse_inside = true
		
		# Don't perform selection action if external selection is active
		if not highlight_active:
			_on_selected()

func _on_mouse_exited() -> void:
	mouse_inside = false

func _on_clicked() -> void:
	# To be implemented by inheriting classes
	pass
	
func _on_selected() -> void:
	emit_signal("selected", self)
	select_sfx.play()

# Triggered by button selector through key/gamepad input
func _on_ext_selected(btn_node):
	if not disabled:
		highlight_active = true
		if btn_node == self:
			ext_selected = true
			
			# Only perform selection action when visible
			if is_visible_in_tree():
				_on_selected()
		
		else:
			ext_selected = false

# Triggered by button selector when the current selection is replaced by mouse movement
func _on_ext_cleared():
	if highlight_active and mouse_inside and not disabled:
		_on_selected()
	highlight_active = false
	ext_selected = false
