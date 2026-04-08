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

static func get_recently_saved():
	pass

static func save_project_file(path:String):
	if path.get_extension() != FILE_EXTENTSION:
		return
	
	Log.info('Saving project at path:', path)
	
	Project.last_save_path = path
	
	var save_time_unix = Time.get_unix_time_from_system()
	var proj_file_dict = {
		'version': FILE_VERSION,
		'save_time': save_time_unix,
		'name': Project.proj_name,
		'system_id': '',
		'palettes': [],
		'tilesets': [],
		'tilemaps': [],
		'context': {
			'selected_palette_index': Context.selected_palette_index,
			'selected_palette_color_index': Context.selected_palette_color_index,
			'Context.selected_palette_bank_index': Context.selected_palette_bank_index,
			'selected_tile_index': Context.selected_tileset_tile_index,
			'selected_map_index': Context.selected_map_index,
			'selected_tabs': {
				'left_panel': Context.selected_left_tab,
				'right_panel': Context.selected_right_tab,
				'main_panel': Context.selected_main_tab
			}
		}
	}
	
	for palette in Project.get_palettes():
		Log.info('Saving palette with name:', palette.palette_name)
		Log.debug('Palette info:', {
			'name': palette.palette_name,
			'colors count': palette.get_colors().size()
		})
		proj_file_dict.palettes.append(serialize_palette(palette))
	
	for tileset in Project.get_tilesets():
		Log.info('Saving tileset with name:', tileset.tileset_name)
		proj_file_dict.tilesets.append(serialize_tileset(tileset))
	
	for map in Project.get_maps():
		Log.info('Saving map with name:', map.map_name)
		proj_file_dict.tilemaps.append(serialize_tilemap(map))
	
	Log.debug('Save dict', proj_file_dict)
	
	var file = FileAccess.open(path, FileAccess.WRITE)
	
	file.store_string(str(proj_file_dict))
	file.close()
	
	
	if !Settings.has_setting('recents', 'saving'):
		Settings.set_setting([] ,'recents', 'saving')
	
	var old_recents = Settings.get_setting('recents', 'saving', '.', []).value
	old_recents.append({
		'name': Project.proj_name,
		'save_time': save_time_unix
	})
	Settings.set_setting(old_recents, 'recents', 'saving')
	Settings.save()

static func serialize_palette(palette:GBPaletteData) -> Dictionary:
	var ret = {
		'name': palette.palette_name,
		'colors': [],
		'type': 'rgb'
	}
	
	if palette is FixedPaletteData:
		ret['fixed_palette_colors'] = palette.get_fixed_colors()
		ret['indexed_colors'] = palette.get_indexed_colors()
		ret['type'] = 'fixed'
		
	for color in palette.get_colors():
		ret.colors.append(color.to_rgba32())
	
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

static func serialize_tilemap(map:GBMapData):
	var ret = {
		'name': map.map_name,
		'map_size': {
			'x': map.size.x, 'y': map.size.y
		},
		'tile_attributes': []
	}
	
	for attrib in map.tile_attrbs:
		var attrib_dict = {
			'tile_index': attrib.tile_index,
			'bank_index': attrib.palette_bank_index,
			'flip_h': attrib.h_flip,
			'flip_v': attrib.v_flip
		}
		ret['tile_attributes'].append(attrib_dict)
	
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
	var tilemaps_arr = proj_file_dict.get('tilemaps', [])
	
	for palette in palettes_arr:
		Project.add_palette(parse_palette(palette))
	for tileset in tilesets_arr:
		Project.add_tileset(parse_tileset(tileset))
	for map in tilemaps_arr:
		Project.add_map(parse_tilemap(map))
	
	Project.palettes_updated.emit()
	Project.tilesets_updated.emit()
	Project.maps_updated.emit()
	
	var context_dict:Dictionary = proj_file_dict.get('context', {})
	if context_dict.is_empty():
		return
	
	Context.selected_palette_index = context_dict.get('selected_palette_index', 0)
	Context.selected_palette_bank_index = context_dict.get('selected_palette_bank_index', 0)
	Context.selected_palette_color_index = context_dict.get('selected_palette_color_index', 0)
	
	Context.selected_tileset_index = context_dict.get('selected_tileset_index', 0)
	Context.selected_map_index = context_dict.get('selected_map_index', 0)
	
	Context.selected_map_index = context_dict.get('selected_map_index', 0)
	pass

static func parse_tilemap(map_dict:Dictionary) -> GBMapData:
	var size = Vector2i(
		map_dict.map_size.x,
		map_dict.map_size.y
	)
	
	var tm = GBMapData.new()
	tm.map_name = map_dict.get('name', 'ERROR')
	
	tm.tile_attrbs.clear()
	
	for attrib in map_dict.get('tile_attributes', []):
		var attrib_data = GBTileAttrib.new()
		attrib_data.tile_index = attrib.get('tile_index', 0)
		attrib_data.palette_bank_index = attrib.get('bank_index', 0)
		attrib_data.h_flip = attrib.get('flip_h', false)
		attrib_data.v_flip = attrib.get('flip_v', false)
		
		tm.tile_attrbs.append(attrib_data)
	
	return tm

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
	if palette_dict.get('type', 'rgb') == 'rgb':
		var pal = RGBPaletteData.new()
		pal.set_palette_name(palette_dict.get('name', 'ERROR'))
		
		var colors_rgb32 = palette_dict.get('colors', [])
		for color in colors_rgb32:
			pal.add_color(Color.hex(color))
		
		return pal
	if palette_dict.get('type', 'rgb') == 'fixed':
		var pal = FixedPaletteData.new()
		pal.set_palette_name(palette_dict.get('name', 'ERROR'))
		pal.register_fixed_colors(palette_dict.get('fixed_palette_colors', []))
		pal._indexed_colors = palette_dict.get('indexed_colors', [])
		
		return pal
	
	return

static func convert_old_file(old_version:String) -> Dictionary:
	return {}
	
