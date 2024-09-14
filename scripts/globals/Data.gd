extends Node

var tutorial_seen : bool = false
var remnant_active : bool = false
var remnant_data : Array[Dictionary] = []

var run_deaths : int = 0
var run_time : float = 0
var remnant_attempt : bool = false

func add_death():
	run_deaths += 1

func add_time(time: float) -> void:
	run_time += time

func submit_remnant_data(new_data: Array[Dictionary]) -> void:
	var past_duration = _get_remnant_data_duration(remnant_data)
	var new_duration = _get_remnant_data_duration(new_data)
	if new_duration >= past_duration:
		remnant_data = new_data

func reset_run():
	run_deaths = 0
	run_time = 0
	
	remnant_active = false
	remnant_data = []

func _get_remnant_data_duration(data: Array[Dictionary]) -> float:
	var duration = 0
	for frame in data:
		duration += frame["delta"]
	return duration
