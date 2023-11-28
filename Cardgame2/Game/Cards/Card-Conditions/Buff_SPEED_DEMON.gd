extends Node


var duration : int = 3
var turns_left : int
var parent_figure : Figure

func create(figure : Figure):
	parent_figure = figure
	figure.conditions["SPEED DEMON"] = self
	turns_left = duration
	figure.add_child(self)
	
func modify_speed() -> int:
	return -1
	
func turn_passed():
	turns_left -= 1
	if turns_left <= 0:
		remove_self()
			
func remove_self():
	parent_figure.conditions.erase("SPEED DEMON")
	self.queue_free()
