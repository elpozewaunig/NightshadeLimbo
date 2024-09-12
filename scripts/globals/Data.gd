extends Node

var tutorial_seen : bool = false

var total_deaths : int = 0
var run_deaths : int = 0

func add_death():
	total_deaths += 1
	run_deaths += 1

func reset_deaths():
	run_deaths = 0
