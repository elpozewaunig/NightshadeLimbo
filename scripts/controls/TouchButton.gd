extends TouchScreenButton

@export var enable_click_sound : bool = false

@onready var click_sfx : AudioStreamPlayer = $ClickSFX

var just_pressed : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Only show when touch is used
	if ControllerHandler.type == ControllerHandler.Type.TOUCH:
		show()
	else:
		hide()
	
	if just_pressed:
		set_deferred("is_just_pressed", false)

func is_just_pressed() -> bool:
	return just_pressed


func _on_pressed() -> void:
	just_pressed = true
	ControllerHandler.touch_haptic_feedback()
	
	if enable_click_sound:
		click_sfx.play()
