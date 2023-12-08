extends Node

var card_stats_dict_sub : Dictionary
var choice_popup = preload("res://Game/Popup_ChoiceMenu.tscn")
var bonusdmg

func resolve_this_card(acting_figure : Figure, choice : pentagon, priority : int):
	if priority == get_parent().get_card_speed(acting_figure)+1:
		if choice.objs_on_this_tile.has("FIGURE"):
			var bonus_damage :int = 0
			if acting_figure.resource["RED"] >= 1:
				var reds = acting_figure.resource["RED"]
				var slice_popup = choice_popup.instantiate()
				get_tree().get_root().get_node("Board/CanvasLayer1").add_child(slice_popup)
				slice_popup.set_up_plus_minus(reds,"RED")
				slice_popup.set_choice_name(acting_figure.figure_type + " Slice add RED")
				var spendresources = await slice_popup.Choice_is_made
				print(spendresources)
				bonus_damage = spendresources*5
				acting_figure.resource["RED"] =  acting_figure.resource["RED"] - spendresources
				slice_popup.queue_free()
			var target = choice.objs_on_this_tile["FIGURE"]
			target.take_damage(10 + bonus_damage)
	

func get_tiles_in_range_sub(acting_figure : Figure, tile_map) -> Array[pentagon]:
	var attack_range : int = card_stats_dict_sub["CARD_RANGE"]
	var attack_tiles = tile_map.get_tiles_in_all_directions(acting_figure.map_position,attack_range,true)
	attack_tiles.pop_front()
	return attack_tiles

