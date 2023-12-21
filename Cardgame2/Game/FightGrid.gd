class_name Map extends Sprite2D

const pentagonTile =  preload("res://Game/pentagon.tscn")
const squareroot3 : float = pow(3,0.5)
var baselength : float = 100
var shortlength = baselength * (squareroot3 - 1)
var pentagonList : Array = []
var gridsizex : int = 6
var gridsizey : int = 4
var top_corner : Vector2 = Vector2(600,120)
var mapscaling : Vector2  = Vector2(0.68,0.5)
var maprotation : float = deg_to_rad(20)
var lit_pentagons : Array[pentagon]
@onready var board_node = get_tree().get_root().get_node("Board")


func get_tiles_in_range(source: pentagon, card_range : int, ghost : bool = true) -> Array[pentagon]:
	var possible_tiles : Array[pentagon] = [source]
	var next_possible_tiles : Array[pentagon] = []
	for r in range(0,card_range):
		for possible_tile in possible_tiles:
			for i in range(0,5):
				if possible_tile.neighbours[i] not in possible_tiles:
					if possible_tile.neighbours[i] not in next_possible_tiles:
						if possible_tile.neighbours[i].blocked == false or ghost == true:
							next_possible_tiles.append(possible_tile.neighbours[i])
		possible_tiles.append_array(next_possible_tiles)
	return possible_tiles

func get_tiles_in_direction(source : pentagon, card_range : int, direction : int,ghost : bool = true) -> Array[pentagon]:
	var possible_tiles : Array[pentagon] = [source]
	var next_possible_tiles : Array[pentagon] = []
	for r in range(0,card_range):
		for possible_tile in possible_tiles:
			if possible_tile.neighbours[direction] not in possible_tiles:
				if possible_tile.neighbours[direction] not in next_possible_tiles:
					if possible_tile.neighbours[direction].blocked == false or ghost == true:
						next_possible_tiles.append(possible_tile.neighbours[direction])
		possible_tiles.append_array(next_possible_tiles)
	return possible_tiles

func get_tiles_in_all_directions(source : pentagon, card_range : int,ghost : bool = true) -> Array[pentagon]:
	var possible_tiles : Array[pentagon] = [source]
	for d in range(0,5):
			possible_tiles.append_array(get_tiles_in_direction(source, card_range,d,ghost))
	return possible_tiles
	
func get_diagonal_tiles_in_range(source : pentagon, card_range : int,ghost : bool = true) -> Array[pentagon]:
	var possible_tiles : Array[pentagon] = [source]
	var next_possible_tiles : Array[pentagon] = []
	for r in range(0,card_range):
		for possible_tile in possible_tiles:
			for i in range(5,7):
				if possible_tile.neighbours[i] not in possible_tiles:
					if possible_tile.neighbours[i] not in next_possible_tiles:
						if possible_tile.neighbours[i].blocked == false or ghost == true:
							next_possible_tiles.append(possible_tile.neighbours[i])
		possible_tiles.append_array(next_possible_tiles)
	return possible_tiles
	

func find_path(start_tile : pentagon, target_tile : pentagon) -> Array[pentagon]:
	var searched_tiles : Array[pentagon] = [start_tile]
	var to_search_tiles : Array[pentagon] = start_tile.get_neighbours()
	var saved_paths : Array = [[start_tile]]
	var iteration_counter : int = 0
	var pathid : int = 0
	while iteration_counter <= 200:
		var next_tiles : Array[pentagon] = []
		for searching_tile in to_search_tiles:
			var neighbour_tiles : Array[pentagon] = searching_tile.get_neighbours()
			for i in range(0,5):
				if !searched_tiles.has(neighbour_tiles[i]):
					var new_path : Array[pentagon] = saved_paths[searched_tiles.find(searching_tile)]
					new_path.append(neighbour_tiles[i])
					pathid += 1
					saved_paths.append(new_path)
					searched_tiles.append(neighbour_tiles[i])
					if !neighbour_tiles[i].blocked:
						next_tiles.append(neighbour_tiles[i])
					if neighbour_tiles[i] == target_tile:
						return saved_paths[pathid]
		to_search_tiles = next_tiles
		iteration_counter += 1
	return saved_paths[0]
		
func find_range(start_tile : pentagon,target_tile : pentagon,) -> int:
	for i in range(0,10):
		if get_tiles_in_range(start_tile,i).has(target_tile):
			return i
	print("ERROR not in RANGE 10")
	return 30
	
func light_up_pentas(pentas : Array[pentagon],light_up_type : Color):
	for penta in pentas:
		penta.lightup_on(light_up_type)
		lit_pentagons.append(penta)

func light_off_pentas():	
	for penta in lit_pentagons:
		penta.lightup_off()
	lit_pentagons.clear()
	#var board_node = get_parent().get_parent()
	if board_node.game_state == "Choose Target":
		if board_node.selected_figure.decision:
			board_node.selected_figure.decision.light_up_in_range()
			
			

		


func get_pentagonList():
	return pentagonList

func generatePentagons(type : String):
	var centricpoints = 4
	var pointoffsetX : Vector2
	var pointoffsetY : Vector2
	print(type)
	match type:
		"p4g":
			pointoffsetX = Vector2(baselength*2,0) + Vector2(shortlength,0).rotated(deg_to_rad(60))
			pointoffsetY = Vector2(0,baselength*2) + Vector2(0,shortlength).rotated(deg_to_rad(60))
			centricpoints = 4
		"cmm":
			pointoffsetX = Vector2(baselength*2,0)
			pointoffsetY = Vector2(0,baselength*2) + Vector2(0,shortlength).rotated(deg_to_rad(60))

			centricpoints = 4
	print(pointoffsetX,pointoffsetY)
	print(baselength)
	print(shortlength)
	print(squareroot3)
	var thispoint : Vector2
	var index : int = 0

	for y in range(0,gridsizey):
		thispoint = y * pointoffsetY #+ top_corner
		for x in range(0,gridsizex):
		
			for o in range(0,centricpoints):
				var thisTile = pentagonTile.instantiate()
				self.add_child(thisTile)
				var thisPenta = thisTile.get_node("Area2D")
				pentagonList.append(thisPenta)
				var pointlist : PackedVector2Array = generatePenta(type,o)
				thisPenta.createPenta(pointlist,thispoint,type,index)
				index = index + 1
			thispoint = thispoint + pointoffsetX
	print(index)
	neighbourcode(pentagonList)

	
			
func neighbourcode(intilelist : Array):
	for i in len(intilelist):
		var ts : int = len(intilelist)
		var tilerotation = i%4
		var ys : int =  gridsizex * 4
		match tilerotation:
			0:
				intilelist[i].set_neighbour(0,intilelist[(i+1)%ts])
				intilelist[i].set_neighbour(1,intilelist[(i+3)%ts])
				intilelist[i].set_neighbour(2,intilelist[(i+ys+2)%ts])
				intilelist[i].set_neighbour(3,intilelist[(i+ys+1)%ts])
				intilelist[i].set_neighbour(4,intilelist[(i-1)%ts])
				intilelist[i].set_neighbour(5,intilelist[(i+2)%ts])
				intilelist[i].set_neighbour(6,intilelist[(i+ys-2)%ts])
			1:
				intilelist[i].set_neighbour(0,intilelist[(i-ys-1)%ts])
				intilelist[i].set_neighbour(1,intilelist[(i+1)%ts])
				intilelist[i].set_neighbour(2,intilelist[(i-1)%ts])
				intilelist[i].set_neighbour(3,intilelist[(i-2)%ts])
				intilelist[i].set_neighbour(4,intilelist[(i-3)%ts])
				intilelist[i].set_neighbour(5,intilelist[(i-ys-2)%ts])
				intilelist[i].set_neighbour(6,intilelist[(i+2)%ts])
				
			2:
				intilelist[i].set_neighbour(0,intilelist[(i-ys+1)%ts])
				intilelist[i].set_neighbour(1,intilelist[(i+3)%ts])
				intilelist[i].set_neighbour(2,intilelist[(i+1)%ts])
				intilelist[i].set_neighbour(3,intilelist[(i-1)%ts])
				intilelist[i].set_neighbour(4,intilelist[(i-ys-2)%ts])
				intilelist[i].set_neighbour(5,intilelist[(i-ys+2)%ts])
				intilelist[i].set_neighbour(6,intilelist[(i-2)%ts])
			3:
				intilelist[i].set_neighbour(0,intilelist[(i-1)%ts])
				intilelist[i].set_neighbour(1,intilelist[(i+2)%ts])
				intilelist[i].set_neighbour(2,intilelist[(i+1)%ts])
				intilelist[i].set_neighbour(3,intilelist[(i+ys-1)%ts])
				intilelist[i].set_neighbour(4,intilelist[(i-3)%ts])
				intilelist[i].set_neighbour(5,intilelist[(i-2)%ts])
				intilelist[i].set_neighbour(6,intilelist[(i+ys+2)%ts])
				
func generatePenta(
	type : String,
	rota : int) -> PackedVector2Array:
		
		var vectorlist : PackedVector2Array = []
		vectorlist.append(Vector2(0,0))
		vectorlist.append(Vector2(0,baselength))
		var calcvec :Vector2
		match type:
			"p4g":
				calcvec = Vector2(0,shortlength).rotated(deg_to_rad(60)) + vectorlist[1]
				vectorlist.append(calcvec)
				calcvec = Vector2(0,baselength).rotated(deg_to_rad(120)) + vectorlist[2] 
				vectorlist.append(calcvec)
				calcvec = Vector2(0,baselength).rotated(deg_to_rad(210)) + vectorlist[3]
				vectorlist.append(calcvec)
			"cmm":
				calcvec = Vector2(0,baselength).rotated(deg_to_rad(90)) + vectorlist[1]
				vectorlist.append(calcvec)
				calcvec = Vector2(0,shortlength).rotated(deg_to_rad(150)) + vectorlist[2] 
				vectorlist.append(calcvec)
				calcvec = Vector2(0,shortlength).rotated(deg_to_rad(210)) + vectorlist[3]
				vectorlist.append(calcvec)
		for i in len(vectorlist):
			vectorlist[i] = vectorlist[i].rotated(deg_to_rad(90*rota))

		#var outpolygon : PackedVector2Array = []
		#for point in vectorlist:
			#point = point + startpoint
			#outpolygon.append(point)
		return vectorlist



	
func _ready():
	self.rotation = maprotation
	self.scale = mapscaling
	self.position = top_corner
	generatePentagons("p4g")
	
	
	
func _process(delta):
	pass
