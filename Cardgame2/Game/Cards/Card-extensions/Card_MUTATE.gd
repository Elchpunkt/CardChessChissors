extends Node

var card_stats_dict_sub : Dictionary
const buffcode = preload("res://Game/Cards/Card-Conditions/Buff_SPEED_DEMON.gd")

func resolve_this_card(acting_figure : Figure, choice : pentagon, priority : int):
	if priority == get_parent().get_card_speed(acting_figure):
		var buff = buffcode.new()
		buff.create(acting_figure)
		acting_figure.add_child(buff)
	

func get_tiles_in_range_sub(acting_figure : Figure) -> Array[pentagon]:
	var movement_range : int = card_stats_dict_sub["CARD_RANGE"]
	var movement_tiles = Globals.tile_map.get_tiles_in_range(acting_figure.map_position,movement_range)
	return movement_tiles
