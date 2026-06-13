extends ExportPlugin
class_name CX16


const X16_TILE_BPPS = [
	'1 bpp',
	'2 bpp',
	'4 bpp',
	'8 bpp',
]

func _init() -> void:
	Project.palettes.palettes_updated.connect(request_update_export_params)

func get_exporter_name() -> String:
	return 'Commander X16'
	
func get_supported_categories() -> Array[String]:
	return['palettes', 'tilesets', 'tilemaps']

func get_export_file_filters() -> Array[String]:
	return ['*.h', '.inc', '.s']

func get_export_params(type:String) -> Dictionary:
	var ret = {}
	if type == 'palettes':
		ret = {
			'palette': {
				'type': ExportPropContainer.TYPE_ENUM,
				'options': Project.palettes.get_palettes().map(
					func(e): return e.palette_name
				),
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
			'bpp': {
				'type': ExportPropContainer.TYPE_ENUM,
				'options': X16_TILE_BPPS,
				'default': 0
			},
		}
	
	return ret

func export(path:String, type:String, params) -> bool:
	return true

func get_preview(type:String, params) -> Control:
	return
