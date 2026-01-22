extends Node


signal Preset_idx_changed(idx:int)
signal selected_palette_changed(new_palette:GBPaletteData)
signal palettes_updated()
signal tilesets_updated()
signal maps_updated()
signal proj_name_changed(new_name:String)

var proj_name = 'Untitled'
var last_save_path:String = ''
var last_save_timestamp:int = 0
var preset_idx:int = 0:
	set(val):
		preset_idx = val
		Preset_idx_changed.emit(val)


var _palettes:Array[GBPaletteData] = []
var _tilesets:Array[GBTileSet] = []
var _maps:Array[GBMapData] = []

func create_initail_project():
	Log.pr('Creating initail Project')
	create_new_project(0)

func create_new_project(preset_id:int):
	preset_idx = preset_id
	var preset = PluginManager.get_system_presets().get(preset_id)
	
	if !preset:
		Log.err('preset id out of bounds. ', preset_idx)
		return
	
	Log.pr('Creating Project with system type:', preset.name)
	Log.debug(preset)
	
	_palettes.clear()
	_tilesets.clear()
	_maps.clear()
	
	_palettes.append(GBPaletteData.new())
	_tilesets.append(GBTileSet.new(Vector2(8, 8)))
	_maps.append(GBMapData.new())
	
	Context.selected_map_index = 0
	Context.selected_tileset_index = 0
	Context.selected_tile_index = 0
	Context.selected_palette_index = 0
	Context.selected_palette_bank_index = 0
	Context.selected_palette_color_index = 0
	
	if preset['palette_mode'] == PluginManager.PALETTE_MODE_FIXED:
		_palettes[Context.selected_palette_index].mode = GBPaletteData.PALETTE_MODE_FIXED
		_palettes[Context.selected_palette_index].register_fixed_palette(preset['fixed_palette_colors'])
		
	if preset['palette_mode'] == PluginManager.PALETTE_MODE_RGB:
		_palettes[Context.selected_palette_index].mode = GBPaletteData.PALETTE_MODE_RGB
	
	for i in range(preset['initial_color_count']):
		_palettes[Context.selected_palette_index].add_color()
	
	_palettes[Context.selected_palette_index].bank_size = preset.get('palette_bank_size', 16)
	
	Exporter.default_exporter = preset.get('default_export_plugin_idx', 0)
	
	_tilesets[0].add_tile()

func clear():
	_tilesets.clear()
	
	_palettes.clear()
	
	proj_name = ''

func get_palettes() -> Array[GBPaletteData]:
	return _palettes

func select_palette(idx:int):
	Context.selected_palette_index = idx
	selected_palette_changed.emit(_palettes[idx])

func get_selected_palette() -> GBPaletteData:
	return _palettes[Context.selected_palette_index]

func add_palette(new_palette:GBPaletteData):
	_palettes.append(new_palette)
	palettes_updated.emit()

func get_tileset(idx:int):
	if _tilesets.is_empty():
		return
	
	return _tilesets[idx]

func get_tilesets() -> Array[GBTileSet]:
	return _tilesets

func add_tileset(tileset:GBTileSet):
	_tilesets.append(tileset)
	tilesets_updated.emit()

func add_map(map:GBMapData):
	_maps.append(map)
	maps_updated.emit()

func get_map(idx:int) -> GBMapData:
	return _maps[idx]

func get_maps() -> Array[GBMapData]:
	Log.debug('Maps:', _maps)
	return _maps
