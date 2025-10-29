class_name ExportContainer
extends ScrollContainer


@onready var export_type_opt: OptionButton = %export_type_opt
@onready var export_plugin_opt: OptionButton = %export_plugin_opt
@onready var export_param_container: ExportPropContainer = %export_param_container

var selected_exporter_idx:int = 0:
	set=set_exporter


func _ready() -> void:
	_populate_export_type_opt()
	_populate_plugin_opt()
	set_exporter(Exporter.default_exporter)
	
	Exporter.exporters_updated.connect(_populate_plugin_opt)
	Exporter.export_type_changed.connect(_populate_plugin_opt)
	Exporter.default_exporter_changed.connect(
		func(idx):
			selected_exporter_idx = idx
	)

func _populate_export_type_opt():
	for type in Exporter.EXPORT_NAMES:
		export_type_opt.add_item(type)
	
	set_exporter(selected_exporter_idx)

func _populate_plugin_opt():
	export_plugin_opt.clear()
	
	var type = Exporter.export_type
	
	for p in Exporter.get_exporters():
		export_plugin_opt.add_item(p._get_exporter_name())

	set_exporter(selected_exporter_idx)

func _on_export_plugin_opt_item_selected(index: int) -> void:
	selected_exporter_idx = index

func set_exporter(val):
	selected_exporter_idx = val
	
	if Exporter.get_exporters().is_empty():
		return
	
	if export_param_container:
		export_param_container.params = Exporter.get_exporters()[selected_exporter_idx]._get_exporter_params()
	
	export_plugin_opt.select(val)

func _on_export_btn_pressed() -> void:
	match Exporter.export_type:
		Exporter.EXPORT_TILES:
			Exporter.export_tiles(selected_exporter_idx, export_param_container.parsed_params)
		Exporter.EXPORT_PALETTE:
			Exporter.export_palette(selected_exporter_idx, export_param_container.parsed_params)
		Exporter.EXPORT_MAP:
			Exporter.export_map(selected_exporter_idx, export_param_container.parsed_params)

func _on_export_type_opt_item_selected(index: int) -> void:
	Exporter.export_type = index
