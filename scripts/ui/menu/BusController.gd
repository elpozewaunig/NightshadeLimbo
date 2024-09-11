extends Node2D

var master_bus : int = AudioServer.get_bus_index("Master")
var music_bus : int = AudioServer.get_bus_index("Music")
var sfx_bus : int = AudioServer.get_bus_index("SFX")

var slider_connections : Array[Dictionary]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Configure which bus sliders affect
	slider_connections = [
		{"slider": $TotalMixSlider, "bus": master_bus},
		{"slider": $MusicSlider, "bus": music_bus},
		{"slider": $SfxSlider, "bus": sfx_bus}
	]
	
	# Connect controller to all slider value changed signals
	for connection in slider_connections:
		pass
		#connection["slider"].value_changed.connect(_on_slider_value_changed)

func _on_slider_value_changed(value: float) -> void:
	# Adjust all bus volumes according to current slider values
	for connection in slider_connections:
		var bus_idx = connection["bus"]
		var slider_value = connection["slider"].slider.value
		var min_value = connection["slider"].slider.min_value
		AudioServer.set_bus_volume_db(bus_idx, slider_value)
		
		if slider_value == min_value:
			AudioServer.set_bus_mute(bus_idx, true)
		else:
			AudioServer.set_bus_mute(bus_idx, false)
