extends Node

var tutorial_seen : bool = false
var ghost_active : bool = false
var ghost_data : Array[Dictionary] = []

var total_deaths : int = 0
var run_deaths : int = 0
var run_time : float = 0

func add_death():
	total_deaths += 1
	run_deaths += 1

func add_time(time: float) -> void:
	run_time += time

func submit_ghost_data(new_data: Array[Dictionary]) -> void:
	var past_duration = _get_ghost_data_duration(ghost_data)
	var new_duration = _get_ghost_data_duration(new_data)
	if new_duration >= past_duration:
		ghost_data = new_data

func reset_run():
	run_deaths = 0
	run_time = 0
	ghost_active = false
	ghost_data = []

func _get_ghost_data_duration(data: Array[Dictionary]) -> float:
	var duration = 0
	for frame in data:
		duration += frame["delta"]
	return duration
