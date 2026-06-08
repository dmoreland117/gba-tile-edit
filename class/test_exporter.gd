extends ExportPlugin
class_name TestExporter


func _init() -> void:
	Project.palettes_updated.connect(request_update_export_params)

func get_exporter_name() -> String:
	return 'GBA Binary'
	
func get_supported_types() -> Array[String]:
	return['palettes']

func get_export_file_filters() -> Array[String]:
	return []

func get_export_params(type:String) -> Dictionary:
	return {
		'palette': {
			'type': ExportPropContainer.TYPE_ENUM,
			'options': Project.get_palettes().map(
				func(e): return e.palette_name
			),
			'default': 0
		}
	}

func export(path:String, type:String, params) -> bool:
	return true
