class_name PNGExporter
extends ExportPlugin


func _get_exporter_name() -> String:
	return 'PNG'

func _get_filters() -> PackedStringArray:
	return ['*.png']

func _export_palette(colors:Array[PaletteColor], path:String, params:Dictionary):
	pass
		
func _export_tiles(tiles:Array[GBTileData], path:String, params):
	var tiles_x = params.get('Tiles X')
	var tiles_y = params.get('Tiles Y')
	var rows = (tiles.size() + tiles_x - 1) / tiles_x
	
	var img = Image.create(
		tiles_x * GBTileData.TILE_SIZE,
		rows * GBTileData.TILE_SIZE,
		false, Image.FORMAT_RGBA8)
	
	for r in range(rows):
		for c in range(tiles_x):
			var tile_img = Image.create(8, 8, false, Image.FORMAT_RGBA8)
			
			
	
func _get_exporter_params() -> Dictionary:
	var params = {}
	
	if Exporter.export_type == Exporter.EXPORT_TILES:
		params['Tiles X'] = {
			'type': TYPE_INT,
			'default': 16
		}
		params['Tiles Y'] = {
			'type': TYPE_INT,
			'default': 16
		}
	
	return params
