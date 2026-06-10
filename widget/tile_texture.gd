class_name TileTexture
extends TextureRect


signal tiles_set()

@export var set_min_size:bool = false

var tiles:Array[GBTileData] = [] : set=set_tiles
var tile_columns:int = 1 : set=set_cols
var palette:GBPaletteData : set=set_palette
var palette_bank:int = 0 : set=set_bank

var _tile_rows:int = 1

var _tile_image:Image


func set_palette(new_palette:GBPaletteData):
	palette = new_palette
	_draw_tiles()
	
	if !palette:
		return
	
	palette.palette_color_updated.connect(
		func(id, col):
			_draw_tiles()
	)

func set_tiles(new_tiles):
	tiles = new_tiles
	
	tile_columns = tile_columns
	
	if new_tiles.is_empty():
		return
	
	_create_image()
	_draw_tiles()
	
	for tile in tiles:
		if !tile:
			return
		
		if !tile.tile_updated.is_connected(_draw_tiles):
			tile.tile_updated.connect(_draw_tiles)

	tiles_set.emit()

func set_cols(cols):
	tile_columns = cols
	_tile_rows = ceil(tiles.size() / tile_columns)
	if _tile_rows == 0:
		_tile_rows = 1
	_draw_tiles()

func set_bank(bank):
	palette_bank = bank
	_draw_tiles()

func _ready() -> void:
	set_tiles(tiles)
	set_palette(palette)
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

func update():
	_draw_tiles()

func get_width() -> int:
	return tile_columns * tiles[0].size.x

func get_height() -> int:
	return _tile_rows * tiles[0].size.y

func _draw_tiles():
	if !_tile_image:
		return
	if tiles.is_empty():
		return
	
	for row in range(_tile_rows):
		for col in range(tile_columns):
			var data = tiles.get(col + (row * tile_columns))
			if !data:
				continue
			
			var offset_x = col * data.size.x
			var offset_y = row * data.size.y
			
			for x in range(data.size.x):
				for y in range(data.size.y):
					var index = data.get_color_index(x, y)
					var color:Color = Color.BLACK
					if palette:
						color = palette.get_color(
							palette_bank + index
						)
					
					_tile_image.set_pixel(
						x + offset_x,
						y + offset_y,
						color
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
	if tiles.size() == 0:
		return
	
	var width_px = tile_columns * tiles[0].size.y
	var height_px = _tile_rows * tiles[0].size.x
	
	_tile_image = Image.create(width_px, height_px, false, Image.FORMAT_RGBA8)
