extends Node

var card_stats_dict_sub : Dictionary

func resolve_this_card(acting_figure : Figure, choice : pentagon, priority : int):
	if priority == 3 and get_parent().check_if_movement_is_possible(acting_figure):
		acting_figure.move_figure(acting_figure.map_position,choice)
	
func play_animation(acting_figure : Figure, choice : pentagon):
	pass	


func get_tiles_in_range_sub(acting_figure : Figure, tile_map) -> Array[pentagon]:
	var movement_range : int = card_stats_dict_sub["CARD_RANGE"]
	var movement_tiles = tile_map.get_tiles_in_range(acting_figure.map_position,movement_range)
	return movement_tiles
