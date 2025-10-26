class_name TileTexture
extends TextureRect


var tile:GBTileData:
	set(val):
		tile = val
		if tile:
			tile.tile_updated.connect(draw_tile)
			draw_tile()

var palette_bank:int = 0 #  0 - 15
var show_grid:bool = false:
	set(val):
		show_grid = val
		queue_redraw()

var _tile_image:Image

func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	
	Project.palette.palette_updated.connect(draw_tile)
	
	if tile and !tile.is_connected('tile_updated', draw_tile):
		tile.tile_updated.connect(draw_tile)
	
	_create_image()
	draw_tile()

func _draw() -> void:
	if show_grid:
		_draw_grid()

func _draw_grid():
	var spacing = size.x / 8
	for i in range (8):
		draw_line(Vector2(0, i * spacing), Vector2(size.x, i * spacing), Color.BLUE)
	for i in range(8):
		draw_line(Vector2(i * spacing, 0), Vector2(i * spacing, size.y), Color.BLUE)
		

func draw_tile():
	if !_tile_image:
		return
	if !tile:
		return
	
	for x in range(GBTileData.TILE_SIZE):
		for y in range(GBTileData.TILE_SIZE):
			var color = Project.palette.get_color(
				Project.palette.bank_and_idx_to_main_idx(
					palette_bank, tile.get_color_index(x, y)))
			_tile_image.set_pixel(x, y, color)
	
	texture = ImageTexture.create_from_image(_tile_image)

func _create_image():
	_tile_image = Image.create(8,8, false, Image.FORMAT_RGBA8)
