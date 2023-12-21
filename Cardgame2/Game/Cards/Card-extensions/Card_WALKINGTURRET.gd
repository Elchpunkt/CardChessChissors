extends Node

var card_stats_dict_sub : Dictionary

func resolve_this_card(acting_figure : Figure, choice : pentagon, priority : int):
	if priority == get_parent().get_card_speed(acting_figure)+1:
		if get_parent().check_movement_possible(choice, priority):
			var newfigure : Figure = Globals.this_board.gen_figure("WALKINGTURRET",acting_figure.figure_owner)
			newfigure.place_figure_on_tile(choice)
		
func play_animation(acting_figure : Figure, choice : pentagon):
	pass	


func get_tiles_in_range_sub(acting_figure : Figure) -> Array[pentagon]:
	var attack_range : int = card_stats_dict_sub["CARD_RANGE"]
	var attack_tiles = Globals.tile_map.get_tiles_in_range(acting_figure.map_position,attack_range,true)
	attack_tiles.pop_front()
	return attack_tiles
