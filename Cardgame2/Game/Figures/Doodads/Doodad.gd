class_name Doodad extends Node2D

var doodad_type : String
var animationstate : String = "Alive"
var map_position : pentagon
var life : int = 45
var display_name : String
var doodad_scene
var creator : Figure

signal doodad_is_clicked(doodad : Doodad)

var DoodadDatas = preload("res://Game/Figures/Doodads/DoodadDatabase.gd")
#@onready var tile_map = get_tree().get_root().get_node("Board").mytilemap

func load_doodad_by_type(type : String, creater : Figure = null):
	doodad_type = type
	creator = creater
	var loaded_array = DoodadDatas.ALLDOODADS[type]
	display_name = loaded_array[0]
	doodad_scene = load(loaded_array[1])
	var doodad_scene_instance = doodad_scene.instantiate()
	$Area2D.add_child(doodad_scene_instance)
	get_tree().get_root().get_node("Board").listen_to_doodad(self)

func place_doodad_on_tile(Mappos : pentagon):
	Mappos.add_obj_to_this_tile("Doodad", self)
	Mappos.blocked = true
	self.map_position = Mappos
	self.position = (Mappos.midpos * Globals.tile_map.mapscaling).rotated(Globals.tile_map.maprotation) + Mappos.global_position
	self.z_index = self.position.y

func remove_doodad_from_tile(standing_tile : pentagon, fromgame : bool = false):
	standing_tile.remove_obj_from_this_tile("DOODAD",self)
	standing_tile.blocked = false
	if fromgame:
		self.queue_free()

func take_damage(damage : int):
	life -= damage
	if life <= 0:
		remove_doodad_from_tile(map_position,true)


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		doodad_is_clicked.emit(self)
