extends Node


signal Preset_idx_changed(idx:int)
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

var palettes:Palettes = Palettes.new()
var _tilesets:Array[GBTileSet] = []
var _maps:Array[GBMapData] = []

var _grids:Array[GridData] = [
	GridData.new()
]


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
	
	palettes.clear()
	_tilesets.clear()
	_maps.clear()
	
	palettes.add_palette(RGBPaletteData.new())
	_tilesets.append(GBTileSet.new(Vector2(8, 8)))
	_maps.append(GBMapData.new())
	
	Context.selected_map_index = 0
	Context.selected_tileset_index = 0
	Context.selected_tileset_tile_index = 0
	Context.selected_palette_index = 0
	Context.selected_palette_bank_index = 0
	Context.selected_palette_color_index = 0
	
	#if preset['palette_mode'] == PluginManager.PALETTE_MODE_FIXED:
		#_palettes[Context.selected_palette_index].mode = GBPaletteData.PALETTE_MODE_FIXED
		#_palettes[Context.selected_palette_index].register_fixed_palette(preset['fixed_palette_colors'])
		#
	#if preset['palette_mode'] == PluginManager.PALETTE_MODE_RGB:
		#_palettes[Context.selected_palette_index].mode = GBPaletteData.PALETTE_MODE_RGB
	
	
	
	#_palettes[Context.selected_palette_index].bank_size = preset.get('palette_bank_size', 16)
	
	#Exporter.default_exporter = preset.get('default_export_plugin_idx', 0)
	
	#if _palettes[0] is FixedPaletteData:
		#_palettes[0].register_fixed_colors([Color.WHITE, Color.GREEN])
	palettes.get_palette(0).add_color()
	_tilesets[0].add_tile()

func clear():
	_maps.clear()
	_tilesets.clear()
	palettes.clear()
	
	proj_name = ''



func get_tileset(idx:int) ->GBTileSet:
	if _tilesets.is_empty():
		return
	
	return _tilesets.get(idx)

func get_selected_tileset() -> GBTileSet:
	return _tilesets.get(Context.selected_tileset_index)

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
	return _maps

class Palettes:
	signal palettes_updated()
	
	var _palettes:Array[GBPaletteData] = []
	
	
	func get_palette(idx:int) -> GBPaletteData:
		return _palettes.get(idx)

	func get_palettes() -> Array[GBPaletteData]:
		return _palettes

	func add_palette(new_palette:GBPaletteData):
		_palettes.append(new_palette)
		palettes_updated.emit()
	
	func clear():
		_palettes.clear()
		palettes_updated.emit()
