extends Node

var card_stats_dict_sub : Dictionary
var choice_popup : PopupMenu 

func resolve_this_card(acting_figure : Figure, choice : pentagon, priority : int):
	if priority == get_parent().get_card_speed(acting_figure)*2:
		if choice.objs_on_this_tile.has("FIGURE"):
			var reds = acting_figure.resource["RED"]
			choice_popup = PopupMenu.new()
			choice_popup.add_multistate_item("ADD RED MARKERS",reds,0,2)
			choice_popup.add_item("ACCEPT",1)
			choice_popup.popup()
			await choice_popup.id_pressed == 1
			var spend_reds = 
			choice_popup.hide()
			choice_popup.queue_free()
			var target = choice.objs_on_this_tile["FIGURE"]
			target.take_damage(10)
	

func get_tiles_in_range_sub(acting_figure : Figure, tile_map) -> Array[pentagon]:
	var attack_range : int = card_stats_dict_sub["CARD_RANGE"]
	var attack_tiles = tile_map.get_tiles_in_range(acting_figure.map_position,attack_range,true)
	attack_tiles.pop_front()
	return attack_tiles

