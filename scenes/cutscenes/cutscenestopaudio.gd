extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../../../../../PERMAPLAYER1".stop()
	$"../../../../../PERMAPLAYER2".stop()
	$"../../../../../PERMAPLAYER3".stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
