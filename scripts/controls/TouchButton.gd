extends TouchScreenButton

@export var enable_click_sound : bool = false
@export var click_color : Color = Color("ff7070")

@onready var click_sfx : AudioStreamPlayer = $ClickSFX

var reset_modulate : Color = modulate

var just_pressed : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


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
	modulate = click_color
	ControllerHandler.touch_haptic_feedback()
	
	if enable_click_sound:
		click_sfx.play()

func _on_released() -> void:
	modulate = reset_modulate
