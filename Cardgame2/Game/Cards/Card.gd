class_name Card extends MarginContainer

var hover : bool = false
var selected : bool = false
var cardname : String
var sprite : Texture
var ingame_pos : int
var hoverscale : float = 1.0
var card_stats_dict
var light_up_color
@onready var tile_map = get_tree().get_root().get_node("Board").mytilemap
var resolve_code
var card_color : Vector3
var priority

var CardDatabase = preload("res://Game/Cards/CardDatabase.gd")
var CardData_Dict = CardDatabase.ALLCARDS
signal Card_is_clicked(clickedcard : Card, triggerplayer : Player)


func _ready():
	pass
	
func load_card(thiscardname : String , startpos : int):
	cardname = thiscardname
	ingame_pos = startpos 
	$Cardname.text = cardname + "  " + str(ingame_pos)
	card_stats_dict = CardData_Dict[thiscardname]
	sprite = load(card_stats_dict["CARDTEXTURE"])
	resolve_code = load(str(card_stats_dict["CARD_CODE"])).new()
	resolve_code.card_stats_dict_sub = card_stats_dict
	add_child(resolve_code)
	$ColorRect/CardArt.set_texture(sprite)
	load_color()
	load_card_color()
	
func load_color():
	match card_stats_dict["CARD_SUPER_TYPE"]:
		"ATTACK":
			light_up_color = Color(1,0,0,0.3)
		"MOVE":
			light_up_color = Color(0,0,0.8,0.3)
		"BUFF":
			light_up_color = Color(0.2,0.5,0.2,0.3)
			
func load_card_color():
	match card_stats_dict["CARD_COLOR"]:
		"RED":
			card_color = Vector3(1,0,0)
		"GREEN":
			card_color = Vector3(0,1,0)
		"BLUE":
			card_color = Vector3(0,0,1)
	$ColorRect/ColorIndicator.modulate = Color(card_color.x,card_color.y,card_color.z,1.0)

func update_card_position(grid_position_index : int, grid_position :Vector2):
		self.set_position(grid_position) 
		self.ingame_pos = grid_position_index
		
func resolve_card(acting_figure : Figure, target_penta : pentagon, priority : int):
		resolve_code.resolve_this_card(acting_figure,target_penta,priority)

func get_tiles_in_range(acting_figure : Figure) -> Array[pentagon]:
	return resolve_code.get_tiles_in_range_sub(acting_figure,tile_map)
	
func check_movement_possible(target : pentagon, priority : int, blocking_figures : Array[Figure] = []) -> bool:
	var is_possible : bool
	if not target.blocked:
		is_possible = true
		for figure in get_tree().get_root().get_node("Board").figurelist:
			if figure != get_parent().owner_figure:
				if figure.decision_target == target:
					if figure.decision.card_stats_dict["CARD_SUPER_TYPE"] == "MOVE":
						if figure.decision.get_card_speed(figure) == priority:
							is_possible = false
							print("2 figures want to move there",get_parent().owner_figure,figure)
	elif target.blocked:	
		is_possible = false
		if target.objs_on_this_tile["FIGURE"]:
			var figure = target.objs_on_this_tile["FIGURE"] 
			if figure.decision.card_stats_dict["CARD_SUPER_TYPE"] == "MOVE":
				if figure.decision.priority == priority:
					if figure.decision_target != target:
						if blocking_figures.has(get_parent().owner_figure):
								is_possible = true
								print("switch places")
						else:
							blocking_figures.append(get_parent().owner_figure)
							if figure.decision.check_movement_possible(figure.decision_target,priority,blocking_figures):
								is_possible = true
								print("target moves away")
	return is_possible
func get_possible_targets():
	pass
	
func light_up_in_range():
	var lightupcolor : Color = light_up_color
	var card_owner_figure = get_parent().owner_figure
	tile_map.light_up_pentas(get_tiles_in_range(card_owner_figure),lightupcolor)
	
func get_card_speed(figure : Figure) -> int:
	priority = card_stats_dict["CARD_PRIORITY"] + figure.get_speed()
	return priority
	
func _process(delta):
	if hover or selected:
		hoverscale = clampf(hoverscale + (5 * delta),1,1.5)	
		self.z_index = 45 + int(selected)*3
		self.scale = Vector2(hoverscale,hoverscale)
	else:
		hoverscale = 1.0
		self.z_index = 42 - ingame_pos*3 
		self.scale = Vector2(hoverscale,hoverscale)
		
		
func _on_button_pressed():
	Card_is_clicked.emit(self,get_parent())
	print("Card is clicked ", cardname, get_parent())
	hoverscale = 1.0
	self.z_index = 42 - ingame_pos*3 
	self.scale = Vector2(hoverscale,hoverscale)

func _on_button_mouse_entered():
	hover = true
	light_up_in_range()
	
func _on_button_mouse_exited():
	hover = false
	tile_map.light_off_pentas()

