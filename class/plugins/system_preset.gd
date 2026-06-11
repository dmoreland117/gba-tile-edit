extends Resource
class_name SystemPreset

enum PaletteMode {
	PALETTE_MODE_FIXED,
	PALETTE_MODE_RGB
}

@export var uid:String
@export var label:String
@export var palette_mode:PaletteMode
@export var palette_bank_size:int
@export var fixed_palette_colors:Array[Color]
@export var initial_color_count:int
@export var initial_map_size:Vector2
@export var default_export_plugin_uid:String


static func from_dict(dict:Dictionary) -> SystemPreset:
	var sp = SystemPreset.new()
	sp.uid = dict.get('uid')
	sp.label = dict.get('label')
	sp.palette_mode = dict.get('palette_mode', PaletteMode.PALETTE_MODE_RGB)
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
	
