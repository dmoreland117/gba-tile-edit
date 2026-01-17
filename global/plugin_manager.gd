extends Node


const PALETTE_TYPE_FIXED = 'fixed'
const PALETTE_TYPE_RGB = 'rgb'
const SCAN_PATHS = [
	'res://plugins'
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


func scan_plugins_dir():
	var dir = DirAccess.open('res://plugins')
	dir.list_dir_begin()
	
	var current = dir.get_next()
	while current != '':
		var current_path = 'res://plugins/' + current + '/' + 'plugin.cfg'
		if !FileAccess.file_exists(current_path):
			printerr('No plugin.cfg found.')
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
