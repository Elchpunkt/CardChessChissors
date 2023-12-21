class_name Deck extends Node2D

const Cards =  preload("res://Game/Cards/Card.tscn")

var deck_list : Array[String] 
var deck_name : String
var stack_with_5 :Array[Card]
var stack_with_4 :Array[Card]
var stack_with_3 :Array[Card]
var stack_with_2 :Array[Card]
var stack_with_1 :Array[Card]
var owner_figure : Figure
var color_stats : Vector3
var deck_draw_side : bool = true

func set_deck_list(thisdeck : Array[String]):
	deck_list = thisdeck
	
func get_deck_list() -> Array[String]:
	return deck_list

func set_deck_name(deckname : String):
	deck_name = deckname
	
func get_deck_name() -> String:
	return deck_name
	
func load_card_for_stack(i : int,stapel : int) -> Card:
	var gencard = Cards.instantiate()
	gencard.load_card(self.deck_list[i],i)
	self.add_child(gencard)
	self.get("stack_with_"+str(stapel)).append(gencard)
	return gencard
	
func move_card(thiscard : Card):
	match thiscard.ingame_pos:
		0:
			self.push_card_in_stack(5)
		5:	
			self.push_card_in_stack(4)
		9:
			self.push_card_in_stack(3)
		12:
			self.push_card_in_stack(2)
		14:
			self.push_card_in_stack(1)
	update_color_stats()
	owner_figure.update_figure_interface.emit(owner_figure)
	

func push_card_in_stack(stapel : int):
	var thisstack = self.get("stack_with_"+str(stapel))
	thisstack.push_front(thisstack.pop_back())
	var summ : int = 15
	for r in range(0,stapel+1):
		summ = summ-r
	print(summ)
	for i in range(0,stapel):
		var cf = i+summ
		thisstack[i].update_card_position(cf)
	update_deck_visuals()
	
func update_deck_visuals():
	for i in range(1,6):
		for card in self.get("stack_with_"+str(i)):
			card.move_card_to_pos(deck_draw_side)
	

func update_color_stats():
	color_stats = Vector3(0,0,0)
	for i in range(1,6):
		color_stats += self.get("stack_with_"+str(i))[0].card_color

func save_deck(playerornot : bool = true):
	var loc
	if playerornot:
		loc = "Own"
	else:
		loc = "Premade"
	if not FileAccess.file_exists("res://Game/Figures/Decks/"+loc+"/"+deck_name+".txt"):
		var to_save_deck = FileAccess.open("res://Game/Figures/Decks/"+loc+"/"+deck_name+".txt", FileAccess.WRITE)
		to_save_deck.store_line(deck_name)
		for savecard in deck_list:
			to_save_deck.store_line(savecard)
	
func load_deck(newdeckname : String,number_of_cards : int = 15):
	var loc
	if FileAccess.file_exists("res://Game/Figures/Decks/Own/"+newdeckname+".txt"):
		loc = "Own"
	else:
		loc = "Premade"
	if FileAccess.file_exists("res://Game/Figures/Decks/"+loc+"/"+newdeckname+".txt"):
		var saved_deck = FileAccess.open("res://Game/Figures/Decks/"+loc+"/"+newdeckname+".txt", FileAccess.READ)
		deck_name = saved_deck.get_line()
		deck_list = []
		print(deck_name)
		for c in range(0,number_of_cards):
			deck_list.append(saved_deck.get_line())
		print(deck_list)
	elif FileAccess.file_exists("res://Game/Figures/Decks/"+loc+"/Minions/"+newdeckname+".txt"):
		var saved_deck = FileAccess.open("res://Game/Figures/Decks/"+loc+"/Minions/"+newdeckname+".txt", FileAccess.READ)
		deck_name = saved_deck.get_line()
		deck_list = []
		print(deck_name)
		for c in range(0,number_of_cards):
			deck_list.append(saved_deck.get_line())
		print(deck_list)
	else:
		print("ERORR  can't find deck!")
		return
