extends Node

var card_stats_dict_sub : Dictionary

func resolve_this_card(acting_figure : Figure, choice : pentagon, priority : int):
	if priority == get_parent().get_card_speed(acting_figure)*2:
		if choice.objs_on_this_tile.has("FIGURE"):
			var target = choice.objs_on_this_tile["FIGURE"]
			target.take_damage(10)
	

func get_tiles_in_range_sub(acting_figure : Figure, tile_map) -> Array[pentagon]:
	var attack_range : int = card_stats_dict_sub["CARD_RANGE"]
	var attack_tiles = tile_map.get_tiles_in_range(acting_figure.map_position,attack_range,true)
	attack_tiles.pop_front()
	return attack_tiles

