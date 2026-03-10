class_name TileTexture
extends TextureRect


signal tiles_set()

@export var set_min_size:bool = false

var tiles:Array[GBTileData] = [] : set=set_tiles
var tile_columns:int = 1 : set=set_cols
var palette_bank:int = 0 : set=set_bank

var tile_rows:int = 1

var _tile_image:Image


func set_tiles(new_tiles):
	tiles = new_tiles
	
	tile_columns = tile_columns
	
	if new_tiles.is_empty():
		return
	
	_create_image()
	_draw_tiles()
	
	for tile in tiles:
		tile.tile_updated.connect(_draw_tiles)

	tiles_set.emit()

func set_cols(cols):
	tile_columns = cols
	tile_rows = ceil(tiles.size() / tile_columns)
	if tile_rows == 0:
		tile_rows = 1
	_draw_tiles()

func set_bank(bank):
	palette_bank = bank
	_draw_tiles()

func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	
	Project.get_selected_palette().palette_updated.connect(_draw_tiles)

func update():
	_draw_tiles()

func get_width() -> int:
	return tile_columns * tiles[0].size.x

func get_height() -> int:
	return tile_rows * tiles[0].size.y

func _draw_tiles():
	if !_tile_image:
		return
	if tiles.is_empty():
		return
	
	for row in range(tile_rows):
		for col in range(tile_columns):
			var data = tiles.get(col + (row * tile_columns))
			if !data:
				continue
			
			var offset_x = col * data.size.x
			var offset_y = row * data.size.y
			
			var palette = Project.get_selected_palette()
			
			for x in range(data.size.x):
				for y in range(data.size.y):
					var index = data.get_color_index(x, y)
					
					_tile_image.set_pixel(
						x + offset_x,
						y + offset_y,
						palette.get_color(
							palette.bank_and_idx_to_main_idx(
								palette_bank, index
							)
						)
					)
	
	texture = ImageTexture.create_from_image(_tile_image)

func get_tile_and_pixel_coords_from_global_pixel_pos(x:int, y:int) -> Dictionary:
	var tile_width = tiles[0].size.x
	var tile_height = tiles[0].size.y
	
	var tile_x = int(x / tile_width)
	var tile_y = int(y / tile_width)
	
	var data = tiles.get(tile_x + tile_y * tile_columns)
	
	var local_tile_x = x % tile_width
	var local_tile_y = y % tile_height
	
	return {
		'data': data,
		'x': local_tile_x,
		'y': local_tile_y
	}

func _create_image():
	var width_px = tile_columns * tiles[0].size.y
	var height_px = tile_rows * tiles[0].size.x
	
	_tile_image = Image.create(width_px, height_px, false, Image.FORMAT_RGBA8)
