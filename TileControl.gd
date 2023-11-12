extends TileMap

var mouse_pos
var tile_pos
var tile_vector
var all_tiles


var texture

# Called when the node enters the scene tree for the first time.
func _ready():
	all_tiles = self.get_used_cells(0)
	for tile in all_tiles:
		self.set_cell(0,tile,2,Vector2i(0,0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	mouse_pos = get_viewport().get_mouse_position()
	tile_pos = local_to_map(to_local(mouse_pos))
	print(tile_pos)
	
	
	for tile in all_tiles:
		if tile != tile_pos:
			self.set_cell(0,tile,2,Vector2i(0,0))
	if tile_pos in all_tiles:
		self.set_cell(0,tile_pos,0,Vector2i(0,0))
