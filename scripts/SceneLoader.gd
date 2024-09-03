extends Node2D

var scene_to_load
var progress = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scene_to_load = SceneManager.switch_to
	AmbienceMusic.play()
	ResourceLoader.load_threaded_request(scene_to_load)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var scene_load_status = ResourceLoader.load_threaded_get_status(scene_to_load, progress)
	
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var scene = ResourceLoader.load_threaded_get(scene_to_load)
		get_tree().change_scene_to_packed(scene)
