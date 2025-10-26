class_name GBAExporter
extends ExportPlugin


enum {
	FILE_C_HEADER,
	FILE_BIN
}

const FILTERS = [
	'*.h',
	'*.bin'
]

var export_type:int = 0


func _get_exporter_name() -> String:
	return 'GBA'

func _get_filters() -> PackedStringArray:
	return [FILTERS[export_type]]

func _export_palette(colors:Array[PaletteColor], path:String, params:Dictionary):
	var arr = PackedByteArray()
	for color_idx in range(0, colors.size()):
		var hi = (colors[color_idx].get_bgr5() >> 8) & 0xFF
		var lo = (colors[color_idx].get_bgr5()) & 0xFF
		
		arr.append(hi)
		arr.append(lo)
	
	var file = FileAccess.open(path, FileAccess.WRITE)
	if !file:
		printerr('could not create file at path ', path)
		return
	
	if export_type == FILE_BIN:
		file.store_buffer(arr)
	if export_type == FILE_C_HEADER:
		file.store_string(Utils.int_array_to_c_char_array(arr, params.get('C Array Name', 'tileset')))
	file.close()

func _export_tiles(tiles:Array[GBTileData], path:String, params):
	var arr = PackedByteArray()
	
	for tile in tiles:
		if params['Color Mode'] == 1:
			arr.append_array(tile.get_8bpp_array())
		if params['Color Mode'] == 0:
			arr.append_array(tile.get_4bpp_array())

	var file = FileAccess.open(path, FileAccess.WRITE)
	if !file:
		printerr('could not create file at path ', path)
		return
	
	if export_type == FILE_BIN:
		file.store_buffer(arr)
	if export_type == FILE_C_HEADER:
		file.store_string(Utils.int_array_to_c_char_array(arr, params.get('C Array Name', 'tileset')))
	file.close()

func _export_map(map:Map, path:String, params:Dictionary):
	var arr = PackedByteArray()
	
	for attr in map.tile_attrbs:
		var val = attr.get_16_bit()
		var hi = (val >> 8) & 0xFF
		var lo = val & 0xFF
		arr.append(lo)
		arr.append(hi)
		
	var file = FileAccess.open(path, FileAccess.WRITE)
	if !file:
		printerr('could not create file at path ', path)
		return
	
	if export_type == FILE_BIN:
		file.store_buffer(arr)
	if export_type == FILE_C_HEADER:
		file.store_string(Utils.int_array_to_c_char_array(
			arr,
			params.get('C Array Name', 'tilemap'),
			[
				'const %s_TILEMAP_WIDTH = %d' % [params.get('C Array Name', 'untitled').to_upper().replace(' ', '_'), map.size.x],
				'const %s_TILEMAP_HEIGHT = %d' % [params.get('C Array Name', 'untitled').to_upper().replace(' ', '_'), map.size.y]
			]))
	file.close()

func _get_exporter_params() -> Dictionary:
	var params = {}
	
	if Exporter.export_type == Exporter.EXPORT_TILES:
		params = {
			'Color Mode': {
				'type': 10000,
				'options': [
					'16 Color',
					'256 Color',
				],
				'tooltip': 'Changes the BPP of the Tileset. \n\n 16 Color (4bpp) \n 256 Color (8bpp)',
				'default': 1
			},
		}
	
	if Exporter.export_type == Exporter.EXPORT_MAP:
		params['Mode'] = {
			'type': 10000,
			'options': [
				'Mode 0',
				'Mode 1',
				'Mode 2',
				'Mode 3',
			],
			'default': 0
		}
	
	params['Export Type'] = {
			'type': 10000,
			'options': [
				'C Header (.h)',
				'Binary (.bin)',
			],
			'on_changed': _on_export_type_changed,
			'default': export_type
		}
	
	if export_type == FILE_C_HEADER:
		params['C Array Name'] = {
			'type': TYPE_STRING,
			'default': Project.proj_name + '_tileset'
		}
	
	return params

func _on_export_type_changed(idx:int):
	export_type = idx
	request_update_params()
