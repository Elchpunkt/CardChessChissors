extends Node

var card_stats_dict_sub : Dictionary

func resolve_this_card(acting_figure : Figure, choice : pentagon, priority : int):
	if priority == get_parent().get_card_speed(acting_figure):
		if get_parent().check_movement_possible(choice, priority):
			acting_figure.move_figure(acting_figure.map_position,choice)
		acting_figure.remove_ghost()
		
func get_tiles_in_range_sub(acting_figure : Figure, tile_map, ghost : bool = true) -> Array[pentagon]:
	var movement_range : int = card_stats_dict_sub["CARD_RANGE"]
	var movement_tiles = tile_map.get_tiles_in_range(acting_figure.map_position,movement_range,ghost)
	movement_tiles.pop_front()
	return movement_tiles
