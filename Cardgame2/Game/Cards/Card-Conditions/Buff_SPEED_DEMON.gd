extends Node



var duration : int = 3
var turns_left : int
var parent_figure : Figure


func create(figure : Figure):
	add_to_group("BUFFS")
	parent_figure = figure
	turns_left = duration
	figure.add_child(self)
	
func modify_speed() -> int:
	return -1
	
func turn_passed():
	turns_left -= 1
	if turns_left <= 0:
		remove_self()
			
func remove_self():
	self.queue_free()
