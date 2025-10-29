extends Node

const EXPORT_NAMES = [
	'Palette',
	'Tileset',
	'Tilemap'
]

enum {
	EXPORT_PALETTE,
	EXPORT_TILES,
	EXPORT_MAP
}

signal export_type_changed()
signal exporters_updated()
signal default_exporter_changed(idx:int)

var export_type:int = EXPORT_PALETTE:
	set(val):
		export_type = val
		export_type_changed.emit()

var exporters:Array[ExportPlugin]
var default_exporter = 0:
	set(val):
		default_exporter = val
		default_exporter_changed.emit(val)

func _ready() -> void:
	_register_commands()

func _register_commands():
	CommandPalette.register_command(
		'exporter:exporttiles',
		[
			{
				'name': 'plugin_id',
				'type': TYPE_INT
			},
		],
		export_tiles
	)

func register_export_plugin(plugin:ExportPlugin):
	plugin.plugin_params_updated.connect(
		func():
			exporters_updated.emit()
	)
	exporters.append(plugin)
	exporters_updated.emit()
	return exporters.size()

func get_exporters() -> Array[ExportPlugin]:
	return exporters

func export_tiles(plugin_idx:int, params:Dictionary):
	var path = await Popups.show_save_file_popup(exporters[plugin_idx]._get_filters())
	exporters[plugin_idx]._export_tiles(Project.tiles.tile_datas, path, params)

func export_palette(plugin_idx:int, params:Dictionary):
	var path = await Popups.show_save_file_popup(exporters[plugin_idx]._get_filters())
	exporters[plugin_idx]._export_palette(Project.palette.colors, path, params)

func export_map(plugin_idx:int, params:Dictionary):
	var path = await Popups.show_save_file_popup(exporters[plugin_idx]._get_filters())
	exporters[plugin_idx]._export_map(Project.map, path, params)
