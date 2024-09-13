extends SelectableArea2DButton
class_name SelectableArea2DToggleButton

@onready var fill_texture : AnimatedSprite2D = $FillTexture

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

func selection_behavior(delta: float) -> void:
	super.selection_behavior(delta)

func default_behavior(delta: float) -> void:
	super.default_behavior(delta)


func click_action() -> void:
	super.click_action()
	active = not active
	toggled.emit(active)
