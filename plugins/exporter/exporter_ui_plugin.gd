extends GBEditPlugin

const EXPORT_CONTAINER = preload("uid://dqc0cy8b1th7t")

var exporter:ExportContainer

func _enter_tree() -> void:
	exporter = EXPORT_CONTAINER.instantiate()
	Ui.get_container(Ui.LEFT_CONTAINER).add_child(exporter)
	
	_register_commands()
	register_exporter_plugin(GBAExporter.new())
	register_exporter_plugin(PNGExporter.new())

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
