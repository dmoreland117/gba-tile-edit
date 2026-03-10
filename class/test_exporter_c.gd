extends ExportPlugin
class_name TestExporterC


func _init() -> void:
	Project.palettes_updated.connect(request_update_export_params)

func get_exporter_name() -> String:
	return 'GBA C Header'
	
func get_supported_types() -> Array[String]:
	return['palettes', 'tilesets']

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
				'options': [
					'4 bpp', '8 bpp'
				],
				'default': 0
			},
			'array_type': {
				'type': TYPE_STRING,
				'default': 'Uint8'
			}
		}
	
	if type == 'tilesets':
		ret = {
			'array_name': {
				'type': TYPE_STRING,
				'default': Project.get_selected_palette().palette_name
			},
			'array_bpp': {
				'type': ExportPropContainer.TYPE_ENUM,
				'options': [
					'4 bpp', '8 bpp'
				],
				'default': 0
			},
			'array_type': {
				'type': TYPE_STRING,
				'default': 'Uint8'
			}
		}
	
	return ret

func export(path:String, type:String, params) -> bool:
	return true
