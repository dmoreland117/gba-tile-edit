class_name ProjectSaver


const FILE_EXTENTSION = 'gbproj'
const FILE_VERSION = 'v1.0'

const VERSION_WHITELIST = [
	'v1.0'
]

const PALETTE_MODES = [
	'fixed',
	'rgb'
]

static func save_project_file(path:String):
	if path.get_extension() != FILE_EXTENTSION:
		return
	
	Project.last_save_path = path
	
	var proj_file_dict = {
		'version': FILE_VERSION,
		'name': Project.proj_name,
		'system_id': '',
		'palettes': [],
		'tilesets': [],
		'tilemaps': [],
		'context': {
			'selected_palette_index': Context.selected_palette_index,
			'selected_palette_color_index': Context.selected_palette_color_index,
			'Context.selected_palette_bank_index': Context.selected_palette_bank_index,
			'selected_tile_index': Context.selected_tile_index,
			'selected_tabs': {
				'left_panel': Context.selected_left_tab,
				'right_panel': Context.selected_right_tab,
				'main_panel': Context.selected_main_tab
			}
		}
	}
	
	for palette in Project.get_palettes():
		proj_file_dict.palettes.append(serialize_palette(palette))
	
	for tileset in Project.get_tilesets():
		proj_file_dict.tilesets.append(serialize_tileset(tileset))
	
	var file = FileAccess.open(path, FileAccess.WRITE)
	
	file.store_string(str(proj_file_dict))
	
	file.close()
	
	pass

static func serialize_palette(palette:GBPaletteData) -> Dictionary:
	var ret = {
		'name': palette.palette_name,
		'mode': PALETTE_MODES[palette.mode],
		'bank_size': palette.bank_size,
		'colors': []
	}
	
	if palette.mode == GBPaletteData.PALETTE_MODE_FIXED:
		ret['fixed_palette_colors'] = palette.fixed_color_palette
	
	for color in palette.colors:
		ret.colors.append(color.get_rgb8())
	
	return ret
	

static func serialize_tileset(tileset:GBTileSet):
	var ret = {
		'name': tileset.tileset_name,
		'tile_size': {
			'x': tileset.tile_size.x, 'y': tileset.tile_size.y
		},
		'tiles': []
	}
	
	for tile in tileset.tile_datas:
		ret.tiles.append(tile.data)
	
	return ret

static func load_project_file(path:String) -> void:
	if path.get_extension() != FILE_EXTENTSION:
		return
	
	if !FileAccess.file_exists(path):
		return
	
	var proj_file_str = FileAccess.get_file_as_string(path)
	if proj_file_str == '':
		return
	
	var proj_file_dict = JSON.parse_string(proj_file_str)
	if !proj_file_dict:
		return
	
	var proj_file_version = proj_file_dict.get('version')
	if !proj_file_version:
		return
	
	if !VERSION_WHITELIST.has(proj_file_version):
		return
	
	Project.clear()
	
	if proj_file_version != FILE_VERSION:
		proj_file_dict = convert_old_file(proj_file_version)
	
	Project.proj_name = proj_file_dict.get('name', 'ERROR')
	Project.last_save_path = path
	
	var palettes_arr = proj_file_dict.get('palettes', [])
	var tilesets_arr = proj_file_dict.get('tilesets', [])
	
	for palette in palettes_arr:
		Project.add_palette(parse_palette(palette))
	for tileset in tilesets_arr:
		Project.add_tileset(parse_tileset(tileset))
	
	Project.palettes_updated.emit()
	Project.tilesets_updated.emit()
	
	var context_dict:Dictionary = proj_file_dict.get('context', {})
	if context_dict.is_empty():
		return
	
	Context.selected_palette_index = context_dict.get('selected_palette_index', 0)
	Context.selected_palette_bank_index = context_dict.get('selected_palette_bank_index', 0)
	Context.selected_palette_color_index = context_dict.get('selected_palette_color_index', 0)
	
	Context.selected_tileset_index = context_dict.get('selected_tileset_index', 0)
	Context.selected_tile_index = context_dict.get('selected_tile_index', 0)
	
	pass

static func parse_tileset(tileset_dict:Dictionary) -> GBTileSet:
	var size = Vector2i(
		tileset_dict.tile_size.x,
		tileset_dict.tile_size.y
	)
	var ts = GBTileSet.new(size)
	ts.tileset_name = tileset_dict.get('name', 'ERROR')
	for tile in tileset_dict.get('tiles', []):
		var tiledata = GBTileData.new(size)
		tiledata.data = tile.map(
			func(e):
				return int(e)
		)
		
		ts.tile_datas.append(tiledata)
	return ts

static func parse_palette(palette_dict:Dictionary) -> GBPaletteData:
	var pal = GBPaletteData.new()
	pal.set_palette_name(palette_dict.get('name', 'ERROR'))
	
	var mode:String = palette_dict.get('mode', 'rgb')
	if mode == 'rgb':
		pal.set_palette_mode(GBPaletteData.PALETTE_MODE_RGB)
	
	pal.bank_size = palette_dict.get('bank_size', 16)
	
	var colors_rgb8 = palette_dict.get('colors', [])
	for color in colors_rgb8:
		pal.colors.append(GBPaletteColor.from_rgb8(color))
	
	return pal

static func convert_old_file(old_version:String) -> Dictionary:
	return {}
	
