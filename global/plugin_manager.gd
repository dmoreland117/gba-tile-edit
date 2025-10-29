extends Node


const PALETTE_TYPE_FIXED = 'fixed'
const PALETTE_TYPE_RGB = 'rgb'

signal system_presets_changed()

var plugins:Array[GBEditPlugin]
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

func load_plugin(path:String) -> int:
	var p = load(path)
	var id = plugins.size()
	
	var pi = p.new()
	
	if pi is not GBEditPlugin:
		printerr('Not a plugin script.')
		return 0
	
	plugins.append(pi)
	add_child(pi)
	
	return id

func remove_plugin(idx:int):
	plugins[idx].queue_free()

func register_system_preset(preset:Dictionary):
	_system_presets.append(preset)
	system_presets_changed.emit()
	
func get_system_presets() -> Array[Dictionary]:
	return _system_presets
