extends Node


signal Preset_idx_changed(idx:int)

var proj_name = 'Untitled'
var last_save_path:String = ''
var last_save_timestamp:int = 0
var preset_idx:int = 0:
	set(val):
		preset_idx = val
		Preset_idx_changed.emit(val)

var palette:GBPaletteData = GBPaletteData.new()
var tiles:GBTileSet = GBTileSet.new()
var map:GBMapData = GBMapData.new()

func create_initail_project():
	create_new_project(0)

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
