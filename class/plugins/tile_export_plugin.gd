class_name ExportPlugin


signal plugin_params_updated()

func request_update_params():
	plugin_params_updated.emit()

func _get_exporter_name() -> String:
	return ''

func _get_exporter_params() -> Dictionary:
	return {}

func _export_palette(colors:Array[GBPaletteColor], path:String, params:Dictionary):
	pass

func _export_tile(tile:GBTileData, path:String, params:Dictionary):
	pass

func _export_tiles(tiles:Array[GBTileData], path:String, params:Dictionary):
	pass

func _export_map(map:GBMapData, path:String, params:Dictionary):
	pass

func _get_filters() -> PackedStringArray:
	return []
