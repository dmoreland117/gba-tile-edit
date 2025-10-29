extends GBEditPlugin

const EXPORT_CONTAINER = preload("uid://dqc0cy8b1th7t")
const NES_PALETTE:Array[Color] = [
	Color(124/255.0, 124/255.0, 124/255.0),
	Color(0/255.0, 0/255.0, 252/255.0),
	Color(0/255.0, 0/255.0, 188/255.0),
	Color(68/255.0, 40/255.0, 188/255.0),
	Color(148/255.0, 0/255.0, 132/255.0),
	Color(168/255.0, 0/255.0, 32/255.0),
	Color(168/255.0, 16/255.0, 0/255.0),
	Color(136/255.0, 20/255.0, 0/255.0),
	Color(80/255.0, 48/255.0, 0/255.0),
	Color(0/255.0, 120/255.0, 0/255.0),
	Color(0/255.0, 104/255.0, 0/255.0),
	Color(0/255.0, 88/255.0, 0/255.0),
	Color(0/255.0, 64/255.0, 88/255.0),
	Color(0/255.0, 0/255.0, 0/255.0),
	Color(0/255.0, 0/255.0, 0/255.0),
	Color(0/255.0, 0/255.0, 0/255.0),
	Color(188/255.0, 188/255.0, 188/255.0),
	Color(0/255.0, 120/255.0, 248/255.0),
	Color(0/255.0, 88/255.0, 248/255.0),
	Color(104/255.0, 68/255.0, 252/255.0),
	Color(216/255.0, 0/255.0, 204/255.0),
	Color(228/255.0, 0/255.0, 88/255.0),
	Color(248/255.0, 56/255.0, 0/255.0),
	Color(228/255.0, 92/255.0, 16/255.0),
	Color(172/255.0, 124/255.0, 0/255.0),
	Color(0/255.0, 184/255.0, 0/255.0),
	Color(0/255.0, 168/255.0, 0/255.0),
	Color(0/255.0, 168/255.0, 68/255.0),
	Color(0/255.0, 136/255.0, 136/255.0),
	Color(0/255.0, 0/255.0, 0/255.0),
	Color(0/255.0, 0/255.0, 0/255.0),
	Color(0/255.0, 0/255.0, 0/255.0),
	Color(248/255.0, 248/255.0, 248/255.0),
	Color(60/255.0, 188/255.0, 252/255.0),
	Color(104/255.0, 136/255.0, 252/255.0),
	Color(152/255.0, 120/255.0, 248/255.0),
	Color(248/255.0, 120/255.0, 248/255.0),
	Color(248/255.0, 88/255.0, 152/255.0),
	Color(248/255.0, 120/255.0, 88/255.0),
	Color(252/255.0, 160/255.0, 68/255.0),
	Color(248/255.0, 184/255.0, 0/255.0),
	Color(184/255.0, 248/255.0, 24/255.0),
	Color(88/255.0, 216/255.0, 84/255.0),
	Color(88/255.0, 248/255.0, 152/255.0),
	Color(0/255.0, 232/255.0, 216/255.0),
	Color(120/255.0, 120/255.0, 120/255.0),
	Color(0/255.0, 0/255.0, 0/255.0),
	Color(0/255.0, 0/255.0, 0/255.0),
	Color(252/255.0, 252/255.0, 252/255.0),
	Color(164/255.0, 228/255.0, 252/255.0),
	Color(184/255.0, 184/255.0, 248/255.0),
	Color(216/255.0, 184/255.0, 248/255.0),
	Color(248/255.0, 184/255.0, 248/255.0),
	Color(248/255.0, 164/255.0, 192/255.0),
	Color(240/255.0, 208/255.0, 176/255.0),
	Color(252/255.0, 224/255.0, 168/255.0),
	Color(248/255.0, 216/255.0, 120/255.0),
	Color(216/255.0, 248/255.0, 120/255.0),
	Color(184/255.0, 248/255.0, 184/255.0),
	Color(184/255.0, 248/255.0, 216/255.0),
	Color(0/255.0, 252/255.0, 252/255.0),
	Color(248/255.0, 216/255.0, 248/255.0),
	Color(0/255.0, 0/255.0, 0/255.0),
	Color(0/255.0, 0/255.0, 0/255.0),
]
var exporter:ExportContainer

func _enter_tree() -> void:
	exporter = EXPORT_CONTAINER.instantiate()
	Ui.get_container(Ui.LEFT_CONTAINER).add_child(exporter)
	
	_register_commands()
	register_exporter_plugin(GBAExporter.new())
	register_exporter_plugin(PNGExporter.new())
	
	register_system_preset(
		{
		'name': 'Nintendo Entertainment System (NES)',
		'palette_type': 'fixed',
		'palette_bank_size': 4,
		'fixed_palette_colors': NES_PALETTE,
		'initial_color_count': 4,
		'initial_map_size': {'x': 32, 'y': 32},
		'default_export_plugin_idx': 1
	}
	)

func _register_commands():
	register_command(
		'exportall',
		[],
		_export_all
	)

func _export_all():
	print('exporting...')
	
	Project.save('res://test_proj.gbproj')

	
	return true
