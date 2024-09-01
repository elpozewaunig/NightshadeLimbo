extends Node2D  # or whatever node type you're using

var time_elapsed = 0.0
var time_to_show = 7.0  # Time in seconds to wait before showing the node

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()  # Initially hide the node

# Called every frame. `delta` is the elapsed time since the previous frame.
func _process(delta):
	time_elapsed += delta  # Increment the time_elapsed by the time since the last frame
	
	if time_elapsed >= time_to_show:
		show()  # Make the node visible
		set_process(false)  # Stop processing after the node is shown
