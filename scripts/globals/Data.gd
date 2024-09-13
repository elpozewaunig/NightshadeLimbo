extends Node

var tutorial_seen : bool = false
var ghost_data : Array[Dictionary] = []

var total_deaths : int = 0
var run_deaths : int = 0

func add_death():
	total_deaths += 1
	run_deaths += 1

func reset_run():
	run_deaths = 0
	ghost_data = []
