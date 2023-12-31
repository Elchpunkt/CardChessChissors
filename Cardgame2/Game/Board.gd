extends Control

const Cards =  preload("res://Game/Cards/Card.tscn")
const Figures = preload("res://Game/Figures/Figure.tscn")
const Players = preload("res://Game/Player.tscn")
const Decks = preload("res://Game/Figures/Decks/Deck.tscn")
#@onready var mytilemap = get_node("CanvasLayer0/Map")
var rng = RandomNumberGenerator.new()

var grid_itemsP : Array[Card]
var grid_itemsO : Array[Card]
var loaded_decks : Dictionary = {}
var grid_positionsP : Array[Vector2] = []
var grid_positionsO : Array[Vector2] = []
const gridx : float = 125
const gridy : float = 100
var figurelist : Array[Figure]
var playerlist : Array[Player]
var oneshot = 1
var selected_figure
var selected_card
var game_state = "Place Figure"
var active_player : Player

var penta_is_clicked_func = func penta_is_clicked(clicked_penta : Area2D):
	
	match game_state:
		"Place Figure":
			if oneshot == 1:
				var newfigure : Figure = gen_figure("MUTANT",playerlist[0])
				newfigure.place_figure_on_tile(clicked_penta)
				oneshot = 2
			elif oneshot == 2:
				var newfigure : Figure = gen_figure("SOLDIER",playerlist[1])
				newfigure.place_figure_on_tile(clicked_penta)
				oneshot = 3
				game_state = "Choose Figure"
				active_player = playerlist[0]
				$CanvasLayer1/GameControls/Active_player.text = active_player.player_name
		"Choose Figure":
			if clicked_penta.objs_on_this_tile.has("FIGURE"):
				figureisclicked.call(clicked_penta.objs_on_this_tile.FIGURE)
		"Choose Aktion":
			if clicked_penta.objs_on_this_tile.has("FIGURE"):
				figureisclicked.call(clicked_penta.objs_on_this_tile.FIGURE)

		"Choose Target":
			var possible_tiles = selected_figure.decision.get_tiles_in_range(selected_figure)
			if clicked_penta in possible_tiles:
				selected_figure.set_decision_target(clicked_penta)
				resolve_turn()
			else:
				print("Out of Range")
		"Wait":
			pass
		"Resolve Turn":
			pass
			
var figureisclicked = func figure_is_clicked(figure : Figure):
	match game_state:
		"Choose Figure","Choose Aktion":
				show_deck(figure)
				if figure.figure_owner == active_player:
					if selected_figure:
						selected_figure.lightoff()
					selected_figure = figure
					selected_figure.lightup()
					game_state = "Choose Aktion"
				
var doodadisclicked = func doodad_is_clicked(doodad : Doodad):
	doodad.modulate = Color(0.5,0.5,0.5,1)
			

var cardselected = func card_is_selected(thiscard : Card, thisdeck : Deck):
	print("Card is clicked ->",thiscard.cardname)
	if game_state == "Choose Aktion" or game_state == 	"Choose Target":
		print(game_state)
		if selected_figure == thisdeck.owner_figure:
			if thiscard.ingame_pos in [0,2,5,9,14]:
				if selected_figure.decision:
					selected_figure.decision.selected = false
				selected_figure.decision = thiscard
				thiscard.selected = true
				selected_card = thiscard
				Globals.tile_map.light_off_pentas()
				thiscard.light_up_in_range()
				game_state = "Choose Target"
				
var undocardselect = func undo_card_selected():
	if game_state == "Choose Target":
		game_state = "Choose Aktion"
		selected_figure.decision = null
		if selected_card:
			selected_card.selected = false
			selected_card = null
		Globals.tile_map.light_off_pentas()
	elif game_state == "Choose Aktion":
		game_state = "Choose Figure"
		selected_figure.lightoff()
		selected_figure = null

		
var selectnextfigure = func selcet_next_figure():
	var next_figure = figurelist[(figurelist.find(selected_figure) + 1)%len(figurelist)]
	next_figure.map_position.penta_being_clicked.emit(next_figure.map_position)

func resolve_turn():
	var allready : int = 0
	for figure in figurelist:
		if figure.figure_owner.is_player == true:
			allready += 1
			if figure.decision and figure.decision_target:
				allready -= 1
			else:
				print("waiting for second choice")
	if allready == 0:
		for figure in figurelist:
			if figure.figure_owner.is_player == false:
				figure.figure_owner.npc_random_action(figure)
				figure.figure_owner.npc_random_direction(figure,figure.decision)
		game_state = "Resolve Turn"
		for i in range(1,12):
			await resolve_priority(i)
		for figure in figurelist:
			if figure.decision:
				figure.figure_deck.move_card(figure.decision)
			if figure.is_controllable:
				figure.decision.selected = false
				figure.decision = null
			else:
				figure.generate_choice()
				print(figure.figure_type,figure.decision.cardname)
		
		set_active_player(playerlist[0])
		get_tree().call_group("BUFFS","turn_passed")
	var player_done : int = 0
	for figure in figurelist:
		if figure.figure_owner == active_player:
			player_done += 1
			if figure.decision:
				player_done -= 1
	if player_done == 0:
		set_active_player(playerlist[(1+playerlist.find(active_player))%len(playerlist)])
	selected_figure.lightoff()
	selected_figure = null
	selected_card.selected = false
	selected_card = null
	game_state= "Choose Figure"
	Globals.tile_map.light_off_pentas()
		
func resolve_priority(priority : int):
	for figure in figurelist:
		if figure.decision:
			await figure.decision.resolve_card(figure,figure.decision_target,priority)
		
	for figure in figurelist:
		figure.update_figure_position()
		

		
func gen_figure(figure_type : String, figureowner : Player) -> Figure:
	var newfigure = Figures.instantiate()
	newfigure.set_figure_owner(figureowner)
	newfigure.load_figure_bytype(figure_type)
	Globals.tile_map.add_child(newfigure)
	$CanvasLayer1/GameControls.listen_to_figure(newfigure)
	newfigure.connect("figure_is_clicked",figureisclicked)
	figurelist.append(newfigure)
	load_deck(newfigure,figureowner)
	return newfigure

func gen_grid():
	for x in range(0,5):
		for y in range(0,5-x):
			grid_positionsP.append(Vector2(100 + x * gridx, 300 + gridy * 5 - y * gridy))
	for x in range(0,5):
		for y in range(0,5-x):
			grid_positionsO.append(Vector2(1720 - x * gridx, 300 + gridy * 5 - y * gridy))
	grid_positionsO.reverse()
	grid_positionsP.reverse()
	
func listen_to_map(thismap):
	var pentalist = thismap.get_pentagonList()
	for cpenta in pentalist:
		cpenta.connect("penta_being_clicked",penta_is_clicked_func)
		
func listen_to_doodad(doodad : Doodad):
	doodad.connect("doodad_is_clicked",doodadisclicked)
	
func load_deck(ownerFigure : Figure, ownerPlayer : Player):
	var deckobj = Decks.instantiate()
	var number_of_cards : int = 15
	if !ownerFigure.is_controllable:
		number_of_cards = 3
	deckobj.load_deck(ownerFigure.figure_deck_name, number_of_cards)
	deckobj.owner_figure = ownerFigure
	ownerPlayer.add_child(deckobj)
	ownerFigure.figure_deck = deckobj
	var c = 1
	for i in range(0,len(deckobj.deck_list)):
		var newcard = deckobj.load_card_for_stack(i,c)
		newcard.connect("Card_is_clicked",cardselected)
		if i == 0 or i == 2 or i == 5 or i == 9:
			c += 1 
	hide_deck(ownerPlayer)
	
#	for i in range(0,5):
#		var newcard = deckobj.load_card_for_stack(i,5,grid[i])
#		newcard.connect("Card_is_clicked",cardselected)
#
#	for i in range(5,9):
#		var newcard = deckobj.load_card_for_stack(i,4,grid[i])
#		newcard.connect("Card_is_clicked",cardselected)
#
#	for i in range(9,12):
#		var newcard = deckobj.load_card_for_stack(i,3,grid[i])
#		newcard.connect("Card_is_clicked",cardselected)
#
#	for i in range(12,14):
#		var newcard = deckobj.load_card_for_stack(i,2,grid[i])
#		newcard.connect("Card_is_clicked",cardselected)
#
#	var newcard = deckobj.load_card_for_stack(14,1,grid[14])
#	newcard.connect("Card_is_clicked",cardselected)
#
func show_deck(figure : Figure):
	if figure.figure_owner == active_player:
		hide_deck(figure.figure_owner)
		figure.figure_deck.deck_draw_side = true
	else:
		for player in playerlist:
			if player != active_player:
				hide_deck(player)
		figure.figure_deck.deck_draw_side = false
	figure.figure_deck.update_deck_visuals()
	figure.figure_deck.visible = true
		
func hide_deck(player : Player):
	for deck in player.get_children():
		deck.visible = false


func set_active_player(player : Player):
	hide_deck(active_player)
	active_player = player
	hide_deck(player)
	$CanvasLayer1/GameControls/Active_player.text = active_player.player_name

func _ready():
	#Standart deck generator
	var stndrtdck = Decks.instantiate()
	stndrtdck.set_deck_name("StandartDeck")
	var stndrtlst : Array[String] = ["SLICE","MUTATE","DASH","SLICE","SLICE","SLICE","SLICE",
		"SLICE","SLICE","SLICE","SLICE","SLICE","SLICE","SLICE","SLICE"]
	stndrtdck.set_deck_list(stndrtlst)
	stndrtdck.save_deck(false)
	#standart 2 player game
	var player1 = Players.instantiate()
	player1.set_playerid(1)
	player1.set_is_player(true)
	player1.player_name = "Player One"
	var player2 = Players.instantiate()
	player2.set_playerid(2)
	player2.set_is_player(true)
	player2.player_name = "Player Two"
	$CanvasLayer1/GameControls.add_child(player1)
	$CanvasLayer1/GameControls.add_child(player2)
	playerlist.append(player1)
	playerlist.append(player2)
	Globals.tile_map.get_pentagonList()
	listen_to_map(Globals.tile_map)
	gen_grid()

# All Keyboard inputs HERE
	
func _input(event):
	if game_state == "Choose Aktion" or game_state == "Choose Target":
		if event.is_action_pressed("Cardslot1"):
			cardselected.call(selected_figure.figure_deck.stack_with_1[0],selected_figure.figure_deck)
		elif event.is_action_pressed("Cardslot2"):
			cardselected.call(selected_figure.figure_deck.stack_with_2[0],selected_figure.figure_deck)
		elif event.is_action_pressed("Cardslot3"):
			cardselected.call(selected_figure.figure_deck.stack_with_3[0],selected_figure.figure_deck)
		elif event.is_action_pressed("Cardslot4"):
			cardselected.call(selected_figure.figure_deck.stack_with_4[0],selected_figure.figure_deck)
		elif event.is_action_pressed("Cardslot5"):
			cardselected.call(selected_figure.figure_deck.stack_with_5[0],selected_figure.figure_deck)
		elif event.is_action_pressed("UnchooseCard"):
			undocardselect.call()
	if game_state == "Choose Figure" or game_state == "Choose Aktion":
		if event.is_action_pressed("TabtoSelect"):
			selectnextfigure.call()
			
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var screensize = Vector2(get_viewport().size)
	var mousepos = get_local_mouse_position() - screensize/2.0
	if selected_figure:
		$Camera2D.set_position(selected_figure.get_global_position()- screensize/2.0)
	else:
		$Camera2D.set_position(mousepos/screensize*150)
