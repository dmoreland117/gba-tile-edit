extends ExportPlugin
class_name GBABinExporter


func _init() -> void:
	Project.palettes_updated.connect(request_update_export_params)

func get_exporter_name() -> String:
	return 'GBA Binary'
	
func get_supported_types() -> Array[String]:
	return['palettes', 'tilesets']

func get_export_file_filters() -> Array[String]:
	return ['*.bin']

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
		}
	
	return ret

func export(path:String, type:String, params) -> bool:
	return true

func get_preview(type:String, params) -> Control:
	return
