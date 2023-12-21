extends CollisionPolygon2D

@onready var this_figure : Figure = get_parent().get_parent()

func generate_choice():
	var possible_attack_targets : Array[pentagon] = []
	var possible_attack_tiles : Array[pentagon] = this_figure.figure_deck.stack_with_1[0].get_tiles_in_range(this_figure)
	var distances : Array[int] = []
	for figure in Globals.this_board.figurelist:
		if figure.figure_owner != this_figure.figure_owner:
			if possible_attack_tiles.has(figure.map_position):
				possible_attack_targets.append(figure)
				distances.append(Globals.tile_map.find_range(this_figure.map_position,figure.map_position,))
	if possible_attack_targets:			
		var min : int = 0
		for i in range(0,len(distances)):
			if distances[i] < distances[min]:
				min = i
		this_figure.decision = this_figure.figure_deck.stack_with_1[0]
		this_figure.decision_target = possible_attack_targets[min].map_position
	else:
		this_figure.decision = this_figure.figure_deck.stack_with_2[0]
		if this_figure.decision.cardname == "WALK":
			for figure in Globals.this_board.figurelist:
				if figure.figure_owner != this_figure.figure_owner:
					possible_attack_targets.append(figure)
					distances.append(Globals.tile_map.find_range(this_figure.map_position,figure.map_position,))
			var min : int = 0
			for i in range(0,len(distances)):
				if distances[i] < distances[min]:
					min = i
			this_figure.decision_target = Globals.tile_map.find_path(this_figure.map_position,possible_attack_targets[min].map_position)[1]
		else:
			this_figure.decision_target = this_figure.map_position
	
