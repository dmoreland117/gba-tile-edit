class_name ExportContainer
extends ScrollContainer


@onready var export_type_opt: OptionButton = %export_type_opt
@onready var export_format_opt: OptionButton = %export_format_opt
@onready var export_param_container: ExportPropContainer = %export_param_container
@onready var file_path_input: LineEdit = %file_path_input
@onready var preview_container: VBoxContainer = %preview_container

var selected_export_type_idx:int = 0 : set=set_selected_export_type_idx
var selected_export_type:String
var selected_export_format:int = 0 : set=set_selected_export_format
var export_path:String = '' : set=set_export_path
var preview_control:Control : set=set_preview

var selected_export_formats:Array[ExportPlugin]


func set_preview(control:Control):
	preview_control = control
	
	if !preview_container:
		return
	
	for child in preview_container.get_children():
		preview_container.remove_child(child)
		child.queue_free()
		
	if control:
		preview_container.add_child(control)

func set_export_path(path:String):
	export_path = path
	
	if file_path_input:
		file_path_input.text = path

func set_selected_export_format(val):
	selected_export_format = val
	
	var f = Exporter.export_plugins.get(val)
	if f:
		export_param_container.params = f.get_export_params(selected_export_type)
		
		f.export_params_update_requested.connect(
			func():
				export_param_container.params = f.get_export_params(selected_export_type)
		)
		
		preview_control = f.get_preview(selected_export_type, export_param_container.get_parsed_params())
		return
	
	selected_export_format = 0
	export_param_container.params = {}

func set_selected_export_type_idx(val):
	selected_export_type_idx = val
	selected_export_type = Exporter.export_types.get(selected_export_type_idx)
	
	_populate_export_type_opt()
	_populate_export_format_opt()
	
	set_selected_export_format(selected_export_format)

func _populate_export_type_opt():
	export_type_opt.clear()
	
	for type in Exporter.get_export_types():
		export_type_opt.add_item(type.capitalize())
	
	export_type_opt.selected = selected_export_type_idx

func _populate_export_format_opt():
	export_format_opt.clear()
	selected_export_formats.clear()
	
	var idx = 0
	for type in Exporter.export_plugins:
		if type.get_supported_types().has(Exporter.export_types[selected_export_type_idx]):
			export_format_opt.add_item(type.get_exporter_name(), idx)
		
		idx += 1

func _ready() -> void:
	set_selected_export_type_idx(0)
	Exporter.export_plugins_updated.connect(
		func():
			set_selected_export_type_idx(0)
	)

func _on_export_type_opt_item_selected(index: int) -> void:
	selected_export_type_idx = index

func _on_export_type_params_params_updated() -> void:
	pass

func _on_export_param_container_params_updated() -> void:
	preview_control = Exporter.export_plugins.get(selected_export_format).get_preview(selected_export_type, export_param_container.get_parsed_params())

func _on_export_format_opt_item_selected(index: int) -> void:
	selected_export_format = index

func _on_export_btn_pressed() -> void:
	var type = Exporter.export_types[selected_export_type_idx]
	
	Exporter.export(selected_export_format, 'res://test', type, export_param_container.get_parsed_params())

func _on_file_path_picker_btn_pressed() -> void:
	export_path = await Popups.show_save_file_popup(Exporter.export_plugins.get(selected_export_format).get_export_file_filters())

func _on_file_path_input_text_submitted(new_text: String) -> void:
	var ext = new_text.get_extension()
	if ext.is_empty():
		return
	
	if Exporter.export_plugins.get(selected_export_format).get_export_file_filters().has(ext):
		export_path = new_text
