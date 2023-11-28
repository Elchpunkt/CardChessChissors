class_name Figure extends Node2D


var figure_owner : Player 
var display_name : String
var figure_type : String
var figure_deck_name : String
var figure_deck : Deck
var animationstate : String = "Alive"
var decision : Card
var decision_target : pentagon
var next_position : pentagon
var map_position : pentagon
var life : int = 45
var speed : int
var resource : Dictionary = {}
var conditions : Dictionary = {}
var figure_scene
var figure_ghost


@onready var tile_map = get_tree().get_root().get_node("Board").mytilemap

signal update_figure_interface(figure : Figure)

var FigureDatas = preload("res://Game/Figures/FigureDatabase.gd")

signal figure_is_clicked(clicked_figure : Figure)

func load_figure_bytype(type : String):
	figure_type = type
	var loaded_array = FigureDatas.ALLFIGURES[type]
	display_name = loaded_array[0]
	figure_scene = load(loaded_array[1])
	var figure_scene_instance = figure_scene.instantiate()
	self.add_child(figure_scene_instance)
	figure_deck_name = loaded_array[2]
	
func set_decision_target(target_tile):
	decision_target = target_tile
	if not decision_target == map_position and decision.card_stats_dict["CARD_SUPER_TYPE"] == "MOVE":
		create_ghost(target_tile)
	
func create_ghost(target_tile):
	remove_ghost()
	var figure_scene_instance = figure_scene.instantiate()
	figure_scene_instance.modulate = Color(1,1,1,0.8)
	get_parent().get_parent().add_child(figure_scene_instance)
	figure_scene_instance.position = (target_tile.midpos * tile_map.mapscaling).rotated(tile_map.maprotation) + target_tile.global_position
	figure_ghost = figure_scene_instance
	
func remove_ghost():
	if figure_ghost:
		figure_ghost.queue_free()
		figure_ghost = null
		
func set_figure_owner(thisowner : Player):
	figure_owner = thisowner
	
func get_figure_owner() -> Player:
	return figure_owner
	
func lightup():
	self.modulate = Color(1,0,1,1)
	
func lightoff():
	self.modulate = Color(1,1,1,1)
	
func move_figure(from_tile : pentagon, to_tile : pentagon):
	self.remove_figure_from_tile(from_tile)
	next_position = to_tile
	
func update_figure_position():
	if next_position:
		place_figure_on_tile(next_position)
		next_position = null
	
func place_figure_on_tile(Mappos : pentagon):
	Mappos.add_obj_to_this_tile("FIGURE", self)
	self.map_position = Mappos
	self.position = (Mappos.midpos * tile_map.mapscaling).rotated(tile_map.maprotation) + Mappos.global_position

func remove_figure_from_tile(standing_tile : pentagon, fromgame : bool = false):
	standing_tile.remove_obj_from_this_tile("FIGURE")
	if fromgame:
		self.queue_free()
		
func take_damage(damage : int):
	life -= damage
	update_figure_interface.emit(self)
	if life <= 0:
		print("Game Over")
		await get_tree().create_timer(5.0).timeout
		get_tree().quit()

		
		
func get_speed() -> int:
	speed = 2
	for condition in conditions.values():
		if condition.has_method("modify_speed"):
			speed += condition.modify_speed
	speed = clamp(speed,1,4)
	return speed
	
func _ready():
	pass


func _on_area_2d_mouse_entered():
	pass # Replace with function body.


func _on_area_2d_mouse_exited():
	pass # Replace with function body.


func _on_area_2d_input_event(viewport, event, shape_idx):
	pass # Replace with function body.
