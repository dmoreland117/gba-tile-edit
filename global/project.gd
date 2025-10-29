extends Node


enum {
	TILE_MODE_4BPP,
	TILE_MODE_8BPP
}

signal Preset_idx_changed(idx:int)

var proj_name = 'Untitled'
var tile_mode:int = TILE_MODE_8BPP
var needs_save:bool = false
var last_save_path:String = ''
var preset_idx:int = 0:
	set(val):
		preset_idx = val
		Preset_idx_changed.emit(val)

var palette:GBPalette = GBPalette.new()
var tiles:GBTileSet = GBTileSet.new()
var map:Map = Map.new()

func create_initail_project():
	var preset = PluginManager.get_system_presets()[0]
	
	if preset['palette_type'] == PluginManager.PALETTE_TYPE_FIXED:
		palette.mode = palette.PALETTE_MODE_FIXED
		palette.register_fixed_palette(preset['fixed_palette_colors'])
		
	if preset['palette_type'] == PluginManager.PALETTE_TYPE_RGB:
		palette.mode = palette.PALETTE_MODE_RGB
	
	for i in range(preset['initial_color_count']):
		palette.add_color()
	
	palette.bank_size = preset.get('palette_bank_size', 16)
	tiles.add_tile()

func create_new_project(preset_id:int):
	preset_idx = preset_id
	var preset = PluginManager.get_system_presets().get(preset_id)
	
	if !preset:
		printerr('preset id out of bounds. ', preset_idx)
		return
	
	palette.clear()
	tiles.clear()
	map.clear()
	
	if preset['palette_type'] == PluginManager.PALETTE_TYPE_FIXED:
		palette.mode = palette.PALETTE_MODE_FIXED
		palette.register_fixed_palette(preset['fixed_palette_colors'])
		
	if preset['palette_type'] == PluginManager.PALETTE_TYPE_RGB:
		palette.mode = palette.PALETTE_MODE_RGB
	
	for i in range(preset['initial_color_count']):
		palette.add_color()
	
	palette.bank_size = preset.get('palette_bank_size', 16)
	Exporter.default_exporter = preset.get('default_export_plugin_idx', 0)
	tiles.add_tile()

func save(path:String):
	var dict = {
		'name': proj_name,
		'save_path': path,
		'palette': palette.to_dict(),
		'tileset': tiles.to_dict(),
		'map': map.to_dict()
	}
	
	last_save_path = path
	
	var file = FileAccess.open(path, FileAccess.WRITE)
	if !file:
		return
	
	file.store_string(str(dict))
	
	file.close()

func load(path:String):
	var dict_String = FileAccess.get_file_as_string(path)
	if dict_String.is_empty():
		return
	
	var dict = JSON.parse_string(dict_String)
	proj_name = dict.get('name', 'Untitled')
	last_save_path = path
	GBPalette.from_dict(dict['palette'], palette)
	GBTileSet.from_dict(dict['tileset'], tiles)
	Map.from_dict(dict['map'], map)
