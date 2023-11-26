class_name Player extends Control

var is_player : bool
var playerid : int
	
func set_is_player(c : bool):
	is_player = c

func set_playerid(id : int):
	playerid = id
	
func get_is_player() -> bool:
	return is_player

func get_playerid() -> int:
	return playerid

func npc_random_action(figure : Figure):
	var choice_deck = figure.figure_deck
	var random_stack = get_tree().get_root().get_node("Board").rng.randi_range(1,5)
	figure.decision = choice_deck.get("stack_with_"+str(random_stack))[0]
	
func npc_random_direction(figure : Figure, card : Card):
	var possible_targets = card.get_tiles_in_range(figure)
	figure.decision_target = possible_targets[get_tree().get_root().get_node("Board").rng.randi_range(0,len(possible_targets)-1)]
