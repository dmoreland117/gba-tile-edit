extends ExportPlugin
class_name GBACHeaderExporter

const ARRAY_TYPES = [
	'16 Color',
	'256 Color'
]

enum {
	ARRAY_MODE_4BPP,
	ARRAY_MODE_8BPP
}


func _init() -> void:
	Project.palettes.palettes_updated.connect(request_update_export_params)

func get_exporter_name() -> String:
	return 'GBA Dexkit Pro C Header'
	
func get_supported_types() -> Array[String]:
	return['palettes', 'tilesets', 'tilemaps']

func get_export_file_filters() -> Array[String]:
	return ['*.h']

func get_export_params(type:String) -> Dictionary:
	var ret = {}
	if type == 'palettes':
		ret = {
			'palette': {
				'type': ExportPropContainer.TYPE_ENUM,
				'options': Project.get_palettes().map(
					func(e): return e.palette_name
				),
				'default': 0
			},
			'array_name': {
				'type': TYPE_STRING,
				'default': Project.get_selected_palette().palette_name
			},
			'array_bpp': {
				'type': ExportPropContainer.TYPE_ENUM,
				'options': ARRAY_TYPES,
				'default': 0
			},
		}
	
	if type == 'tilesets':
		ret = {
			'tileset': {
				'type': ExportPropContainer.TYPE_ENUM,
				'options': Project.get_tilesets().map(
					func(e): return e.tileset_name
				),
				'default': 0
			},
			'array_name': {
				'type': TYPE_STRING,
				'default': Project.get_selected_palette().palette_name
			},
			'array_bpp': {
				'type': ExportPropContainer.TYPE_ENUM,
				'options': ARRAY_TYPES,
				'default': 0
			},
		}
	
	return ret

func export(path:String, type:String, params) -> bool:
	return true

func get_preview(type:String, params) -> Control:
	var highlighter = CodeHighlighter.new()
	highlighter.number_color = Color.RED
	highlighter.symbol_color = Color(0.78, 0.78, 0.78)
	
	highlighter.add_keyword_color('const', Color(1.0, 0.332, 0.332))
	highlighter.add_keyword_color('u16', Color.GREEN)
	highlighter.add_color_region('//', '', Color(0.0, 0.659, 0.0))
	
	var cb = CodeEdit.new()
	cb.gutters_draw_line_numbers = true
	cb.syntax_highlighter = highlighter
	cb.editable = false
	cb.caret_draw_when_editable_disabled = false
	cb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cb.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	if type == 'palettes':
		var colors = Project.get_palette(params.get('palette', 0)).get_colors()
		var data:Array[int] = []
		
		for color in colors:
			data.append(get_bgr5(color))
		
		cb.text = palette_array_to_c_array(data, params.get('array_name', 'dd'))
	
	
	if type == 'tilesets':
		var tileset = Project.get_tileset(params.get('tileset', 0))
		var data = tileset.get_indexes_array()
		var tile_size_prefixes = [
			'#define TILE_SIZE_X ' + str(tileset.tile_size.x),
			'#define TILE_SIZE_y ' + str(tileset.tile_size.y)
		]
		match params.get('array_bpp'):
			ARRAY_MODE_4BPP:
				var d = tilset_array_to_16_color_c_array(data, params.get('array_name', 'dd'), tile_size_prefixes)
				cb.text = d
			ARRAY_MODE_8BPP:
				var d = tilset_array_to_256_color_c_array(data, params.get('array_name', 'dd'), tile_size_prefixes)
				cb.text = d
	if type == 'tilemaps':
		var attribs = Project.get_map(0).tile_attrbs
		var bytes = []
		for attrib in attribs:
			var low = attrib.tile_index & 0xff
			var hi = (attrib.tile_index >> 8) | (int(attrib.h_flip) << 2) | (int(attrib.v_flip) << 3) | (attrib.palette_bank_index << 4)
			
			bytes.append(low)
			bytes.append(hi)
		cb.text = tilemap_array_to_c_array(bytes, params.get('array_name', 'dd'))
	return cb

func get_bgr5(color:Color) -> int:
	var r5 = clamp(int(color.r8 >> 3), 0, 31)
	var g5 = clamp(int(color.g8 >> 3), 0, 31)
	var b5 = clamp(int(color.b8 >> 3), 0, 31)
	var ret = 0
	ret = (b5 << 10) | (g5 << 5) | r5
	return ret

func tilset_array_to_16_color_c_array(values: PackedByteArray, name: String = "data", prefix_lines: PackedStringArray = []) -> String:
	var result := ""
	
	for prefix in prefix_lines:
		result += prefix + "\n"
	
	result += "\n"
	result += "const u16 " + name + "[" + str(values.size() / 4) + "] = {\n"
	result += "\t// Tile 0 \n"
	
	var words_on_line := 0
	var line_count := 0
	var tile_num := 0
	
	for i in range(0, values.size(), 4):
		var p0: int = values[i] & 0xF
		var p1: int = values[i + 1] & 0xF
		var p2: int = values[i + 2] & 0xF
		var p3: int = values[i + 3] & 0xF
		
		var packed: int = (p1 << 4 | p0) | ((p3 << 4 | p2) << 8)
		
		result += "\t0x%04X" % packed
		
		words_on_line += 1
		
		if i < values.size() - 4:
			result += ","
		
		if words_on_line == 2:
			result += "\n"
			words_on_line = 0
			line_count += 1
			
			if line_count % 8 == 0:
				tile_num += 1
				
				result += "\n"
				result += "\t// Tile %d \n" % tile_num
		else:
			result += " "
	
	result += "};\n"
	return result

func palette_array_to_c_array(values: Array[int], name: String = "data", prefix_lines: PackedStringArray = []) -> String:
	var result := ""
	
	for prefix in prefix_lines:
		result += prefix + "\n"
	
	result += "\n"
	result += "const u16 " + name + "[" + str(values.size() / 2) + "] = {\n"
	
	var words_on_line := 0
	var line_count := 0
	
	for i in values:
		var p0: int = i
		
		var packed: int = p0
		
		result += "\t0x%04X" % packed
		
		words_on_line += 1
		
		if i < values.size() - 2:
			result += ","
		
		if words_on_line == 16:
			result += "\n"
			words_on_line = 0
			line_count += 1
		
		else:
			result += " "
	
	result += "};\n"
	return result

func tilset_array_to_256_color_c_array(values: PackedByteArray, name: String = "data", prefix_lines: PackedStringArray = []) -> String:
	var result := ""
	
	for prefix in prefix_lines:
		result += prefix + "\n"
	
	result += "\n"
	result += "const u16 " + name + "[" + str(values.size() / 2) + "] = {\n"
	
	var words_on_line := 0
	var line_count := 0
	
	for i in range(0, values.size(), 2):
		if i + 1 >= values.size():
			break
		
		var p0: int = values[i] & 0xFF
		var p1: int = values[i + 1] & 0xFF
		
		# 8bpp packing (little endian)
		var packed: int = p0 | (p1 << 8)
		
		result += "\t0x%04X" % packed
		
		words_on_line += 1
		
		if i < values.size() - 2:
			result += ","
		
		if words_on_line == 4:
			result += "\n"
			words_on_line = 0
			line_count += 1
			
			if line_count % 8 == 0:
				result += "\n"
		else:
			result += " "
	
	result += "};\n"
	return result

func tilemap_array_to_c_array(values: PackedByteArray, name: String = "data", prefix_lines: PackedStringArray = []) -> String:
	var result := ""
	
	for prefix in prefix_lines:
		result += prefix + "\n"
	
	result += "\n"
	result += "const u16 " + name + "[" + str(values.size() / 2) + "] = {\n"
	
	var words_on_line := 0
	var line_count := 0
	
	for i in range(0, values.size(), 2):
		if i + 1 >= values.size():
			break
		
		var p0: int = values[i] & 0xFF
		var p1: int = values[i + 1] & 0xFF
		
		# 8bpp packing (little endian)
		var packed: int = p0 | (p1 << 8)
		
		result += "\t0x%04X" % packed
		
		words_on_line += 1
		
		if i < values.size() - 2:
			result += ","
		
		if words_on_line == 32:
			result += "\n"
			words_on_line = 0
			line_count += 1
		else:
			result += " "
	
	result += "};\n"
	return result
