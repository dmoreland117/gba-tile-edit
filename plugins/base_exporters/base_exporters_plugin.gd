extends GBEditPlugin


func _enter_tree() -> void:
	register_exporter_plugin(GBABinExporter.new())
	register_exporter_plugin(GBACHeaderExporter.new())
