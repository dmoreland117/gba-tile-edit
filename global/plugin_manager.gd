extends Node


const PALETTE_TYPE_FIXED = 'fixed'
const PALETTE_TYPE_RGB = 'rgb'
const SCAN_PATHS = [
	'res://plugins',
	'user://plugins'
]

signal system_presets_changed()

var _system_presets:Array[Dictionary] = [
	{
		'name': 'Nintendo Game Boy Advanced (GBA)',
		'palette_type': 'rgb',
		'palette_bank_size': 16,
		'initial_color_count': 4,
		'initial_map_size': {'x': 32, 'y': 32},
		'default_export_plugin_idx': 0
	},
	
]


func scan_dir_paths():
	for path in SCAN_PATHS:
		scan_plugins_dir(path)

func scan_plugins_dir(dir_path:String):
	var dir = DirAccess.open(dir_path)
	dir.list_dir_begin()
	
	var current = dir.get_next()
	while current != '':
		if !dir.current_is_dir():
			current = dir.get_next()
			continue
		
		var current_path = dir_path + '/' + current + '/' + 'plugin.cfg'
		if !FileAccess.file_exists(current_path):
			printerr('No plugin.cfg found. path: ', current_path)
			current = dir.get_next()
			
			continue
			
		load_plugin(current_path)	
		current = dir.get_next()
	
	return

func load_plugin(path:String) -> int:
	var plugin_config = PluginConfig.load_file(path)
	if !plugin_config:
		return -1
	
	var id = get_child_count()
	
	if !plugin_config.plugin_script:
		printerr('Could not load script', )
		return -1
	
	var pi = plugin_config.plugin_script.new()
	
	if pi is not GBEditPlugin:
		printerr('Not a plugin script. path: ', path)
		return 0
	
	add_child(pi)
	
	return id

func remove_plugin(idx:int):
	get_child(idx).queue_free()

func register_system_preset(preset:Dictionary):
	_system_presets.append(preset)
	system_presets_changed.emit()
	
func get_system_presets() -> Array[Dictionary]:
	return _system_presets
