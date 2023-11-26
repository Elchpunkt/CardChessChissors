extends Node

var card_stats_dict_sub : Dictionary

func resolve_this_card(acting_figure : Figure, choice : pentagon, priority : int):
	if priority == get_parent().get_card_speed(acting_figure):
		if not choice.blocked:
			acting_figure.move_figure(acting_figure.map_position,choice)

func get_tiles_in_range_sub(acting_figure : Figure, tile_map, ghost : bool = true) -> Array[pentagon]:
	var movement_range : int = card_stats_dict_sub["CARD_RANGE"]
	var movement_tiles = tile_map.get_tiles_in_range(acting_figure.map_position,movement_range,ghost)
	var to_remove_tiles = tile_map.get_tiles_in_range(acting_figure.map_position,movement_range-1,ghost)
	var possible_tiles : Array[pentagon] =[]
	for tiles in movement_tiles:
		if tiles not in to_remove_tiles:
			possible_tiles.append(tiles)
	return possible_tiles
