extends Control

const Cards =  preload("res://Game/Cards/Card.tscn")
const Figures = preload("res://Game/Figures/Figure.tscn")
const Players = preload("res://Game/Player.tscn")
const Decks = preload("res://Game/Figures/Decks/Deck.tscn")
@onready var mytilemap = get_node("CanvasLayer0/Map")
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

var penta_is_clicked_func = func penta_is_clicked(clicked_penta : Area2D):
	
	match game_state:
		"Place Figure":
			if oneshot == 1:
				var newfigure : Figure = gen_figure("MUTANT",playerlist[0])
				newfigure.place_figure_on_tile(clicked_penta)
				newfigure.connect("update_figure_interface",updatefigureinterface)
				oneshot = 2
			elif oneshot == 2:
				var newfigure : Figure = gen_figure("SOLDIER",playerlist[1])
				newfigure.place_figure_on_tile(clicked_penta)
				newfigure.connect("update_figure_interface",updatefigureinterface)
				oneshot = 3
				game_state = "Choose Figure"
		"Choose Figure":
			if clicked_penta.objs_on_this_tile.has("FIGURE"):
				#if selected_figure.figure_owner.is_player:
				#selected_figure = null
				selected_figure = clicked_penta.objs_on_this_tile.FIGURE
				selected_figure.lightup()
				game_state = "Choose Aktion"
		"Choose Aktion":
			pass

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

var cardselected = func card_is_selected(thiscard : Card, thisdeck : Deck):
	print("Card is clicked ->",thiscard.cardname)
	if game_state == "Choose Aktion" or game_state == 	"Choose Target":
		print(game_state)
		if selected_figure:
			if thiscard.ingame_pos in [0,5,9,12,14]:
				if selected_figure.decision:
					selected_figure.decision.selected = false
				selected_figure.decision = thiscard
				thiscard.selected = true
				selected_card = thiscard
				mytilemap.light_off_pentas()
				thiscard.light_up_in_range()
				game_state = "Choose Target"
				
var undocardselect = func undo_card_selected():
	if game_state == "Choose Target":
		game_state == "Choose Aktion"
		selected_figure.decision = null
		if selected_card:
			selected_card.selected = false
			selected_card = null
		mytilemap.light_off_pentas()
	if game_state == "Choose Aktion":
		selected_figure.lightoff()
		selected_figure = null
		game_state = "Choose Figure"

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
		for i in range(1,6):
			resolve_priority(i)
		for figure in figurelist:
			figure.figure_deck.move_card(figure.decision)
			figure.decision.selected = false
			figure.decision = null
	selected_figure.lightoff()
	selected_figure = null
	selected_card.selected = false
	selected_card = null
	game_state= "Choose Figure"
	mytilemap.light_off_pentas()
		
func resolve_priority(priority : int):
	for figure in figurelist:
		figure.decision.resolve_card(figure,figure.decision_target,priority)
	for figure in figurelist:
		figure.update_figure_position()
		
var updatefigureinterface = func update_figure_interface(figure : Figure):
	print("something takes dmg")
	if figure.figure_owner.playerid == 1:
		$CanvasLayer1/GameControls/Figure_Stats_Loc/PFigureHealth.set_text("Pfigure Life = " + str(figure.life))
	else:
		$CanvasLayer1/GameControls/Figure_Stats_Loc/OFigureHealth.set_text("Ofigure Life = " + str(figure.life))
func gen_figure(figure_type : String, figureowner : Player) -> Figure:
	var newfigure = Figures.instantiate()
	newfigure.set_figure_owner(figureowner)
	newfigure.load_figure_bytype(figure_type)
	mytilemap.add_child(newfigure)
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
	
func listen_to_map(thismap):
	var pentalist = thismap.get_pentagonList()
	for cpenta in pentalist:
		cpenta.connect("penta_being_clicked",penta_is_clicked_func)
	
func load_deck(ownerFigure : Figure, ownerPlayer : Player):
	var deckobj = Decks.instantiate()
	deckobj.load_deck(ownerFigure.figure_deck_name)
	deckobj.owner_figure = ownerFigure
	ownerPlayer.add_child(deckobj)
	ownerFigure.figure_deck = deckobj
	var grid
	if ownerPlayer.playerid == 1:
		grid = grid_positionsP
	else:
		grid = grid_positionsO
	
	for i in range(0,5):
		var newcard = deckobj.load_card_for_stack(i,5,grid[i])
		newcard.connect("Card_is_clicked",cardselected)
		
	for i in range(5,9):
		var newcard = deckobj.load_card_for_stack(i,4,grid[i])
		newcard.connect("Card_is_clicked",cardselected)
		
	for i in range(9,12):
		var newcard = deckobj.load_card_for_stack(i,3,grid[i])
		newcard.connect("Card_is_clicked",cardselected)
		
	for i in range(12,14):
		var newcard = deckobj.load_card_for_stack(i,2,grid[i])
		newcard.connect("Card_is_clicked",cardselected)
		
	var newcard = deckobj.load_card_for_stack(14,1,grid[14])
	newcard.connect("Card_is_clicked",cardselected)
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
	var player2 = Players.instantiate()
	player2.set_playerid(2)
	player2.set_is_player(true)
	$CanvasLayer1/GameControls.add_child(player1)
	$CanvasLayer1/GameControls.add_child(player2)
	playerlist.append(player1)
	playerlist.append(player2)
	mytilemap.get_pentagonList()
	listen_to_map(mytilemap)
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
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var screensize = Vector2(get_viewport().size)
	var mousepos = get_local_mouse_position() - screensize/2.0
	if selected_figure:
		$Camera2D.set_position(selected_figure.get_global_position()- screensize/2.0)
	else:
		$Camera2D.set_position(mousepos/screensize*300)
