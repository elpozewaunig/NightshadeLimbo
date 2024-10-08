extends SelectableArea2DButton
class_name SelectableArea2DToggleButton

@onready var fill_texture : AnimatedSprite2D = $FillTexture
@onready var off_sfx : AudioStreamPlayer = $ClickOffSFX

@export var toggled_fill_color : Color = Color("9e001f")

var active = false

signal toggled(active)

func _process(delta: float) -> void:
	super._process(delta)
	
	if active:
		fill_texture.scale = sprite.scale
		fill_texture.frame = sprite.frame
		fill_texture.modulate = toggled_fill_color
		fill_texture.show()
	else:
		fill_texture.hide()


func click_action() -> void:
	active = not active
	clicked.emit()
	toggled.emit(active)
	if active:
		click_sfx.play()
	else:
		off_sfx.play()
	ControllerHandler.touch_haptic_feedback()
