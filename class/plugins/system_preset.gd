class_name SystemPreset

enum {
	PALETTE_MODE_FIXED,
	PALLET_MODE_RGB
}

var label:String
var palette_mode:int
var palette_bank_size:int
var fixed_palette_colors:Array[Color]
var initial_color_count:int
var initial_map_size:Vector2
var default_export_plugin_idx:int # unused


static func from_dict(dict:Dictionary) -> SystemPreset:
	var sp = SystemPreset.new()
	sp.label = dict.get('label')
	sp.palette_mode = dict.get('palette_mode', 1)
	sp.palette_bank_size = dict.get('palette_bank_size', 4)
	sp.fixed_palette_colors = dict.get('fixed_palette_colors')
	sp.initial_color_count = dict.get('initial_color_count', 4)
	sp.initial_color_count = dict.get('initial_color_count', 4)
	
	var map_size_dict = dict.get('initial_map_size')
	if map_size_dict:
		sp.initial_map_size = Vector2(
			map_size_dict.get('x', 32),
			map_size_dict.get('y', 32)
		)
	else:
		sp.initial_map_size = Vector2(32, 32)
	
	return sp
	
