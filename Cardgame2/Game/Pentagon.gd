class_name pentagon extends Area2D

var penta_index : int
var midpos : Vector2
var neighbours : Array[pentagon] = []
var thispolygon : Polygon2D
var type : String
var hover : bool = false
var transition : float = 0
var polytexture : Texture = load("res://Backgrounds/strangetile2.png")
var polycolor : Color = Color(0.1,0.1,0.1,0.2)
var lightup : bool = false
var lightupcolor :  Color = Color(0,0,0,1)
const hovercolor : Color = Color(0.2,0.2,0.3,0.3)
var objs_on_this_tile : Dictionary = {}
var blocked : bool = false

signal penta_being_clicked(clickedpenta : Area2D)

var onMouseEnterCall = func _onMouseEnter(): 
	hover = true
	
var onMouseExitCall = func _onMouseLeave():
	hover = false

func _unhandled_input(event):
	if hover and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		penta_being_clicked.emit(self)
		
func get_neighbours() -> Array:
	return neighbours
	
func set_neighbour(direction:int,neighbour : pentagon):
	neighbours[direction] = neighbour

func get_pindex() -> int:
	return penta_index

func get_midpos() -> Vector2:
	return midpos
	
#func get_global_middle() -> Vector2:
#	return self.global_position + get_midpos()

	
func add_obj_to_this_tile(objtype : String, something):
	if objtype == "FIGURE":
		blocked = true
		objs_on_this_tile[objtype] = something
	if objtype == "DOODAD":
		objs_on_this_tile[objtype].append(something)
		
func get_obj_on_this_tile():
	return objs_on_this_tile
	
func remove_obj_from_this_tile(objtype : String, what : Node = null):
	if objtype == "FIGURE":
		blocked = false
		objs_on_this_tile.erase(objtype)
	if objtype == "DOODAD":
		objs_on_this_tile[objtype].pop_at(objs_on_this_tile[objtype].find(what))

func createPenta(inpolygon : PackedVector2Array, inposition : Vector2, typein : String, index : int):
	neighbours.resize(7)
	penta_index = index
	type = typein
	thispolygon = Polygon2D.new()
	thispolygon.set_polygon(inpolygon)
	self.position = inposition
	thispolygon.texture = polytexture
	thispolygon.texture_offset = Vector2(fmod(40*index,600),fmod(25*index,600))
	thispolygon.modulate = polycolor
	thispolygon.set_z_as_relative(false)
	thispolygon.set_z_index(-10)
	calcmiddle(inposition)
	self.add_child(thispolygon)
	var shape = CollisionPolygon2D.new()
	shape.set_polygon(thispolygon.get_polygon())
	self.add_child(shape)
	input_pickable = true
	self.connect("mouse_entered",onMouseEnterCall)
	self.connect("mouse_exited",onMouseExitCall)
	set_process(true)
		#outline
	for i in range(0,5):
		$Line2D.add_point(thispolygon.polygon[i])
		#Label
#	var number = Label.new()
#	number.text = str(penta_index)
#	number.position = midpos
#	self.add_child(number)
		#label end
	

func calcmiddle(offsetvec :Vector2):
	var addvec = Vector2(0,0)
	for vec in thispolygon.polygon:
		addvec = addvec + vec
	addvec = addvec / 5
	midpos = addvec
	
func _onready():
	pass

func lightup_on(selectcolor: Color):
	lightupcolor = selectcolor
	lightup = true
			
func lightup_off():
	lightup = false
	lightupcolor = Color(0,0,0,0)

func _process(delta):
	if lightup == true or hover == true:
		if transition < 25:
			transition = transition + (60 * delta)
	elif transition >= 1:
			transition = transition - (60 * delta)
	if transition > 1:
		var gradient : float = float(transition/25)
		thispolygon.modulate = polycolor + gradient * (lightupcolor + hovercolor*float(hover))
