extends PopupPanel


@onready var export_param_container:ExportPropContainer = %export_param_container
@onready var export_category_tabbar:TabBar = %export_category_tabbar
@onready var Preview_container:VBoxContainer = %preview_container


var selected_exporter_id:int = 0 : set=set_selected_exporter_id
var selected_exporter:ExportPlugin : get=get_selected_exporter

var selected_category_id:int = 0 : set=set_selected_category_id


func set_selected_category_id(id:int):
	selected_category_id = id
	
	if !export_param_container or !selected_exporter:
		return
	
	var export_cat_name = selected_exporter.get_supported_categories().get(selected_category_id)
	export_param_container.params = selected_exporter.get_export_params(export_cat_name)

func set_selected_exporter_id(id:int):
	selected_exporter_id = id
	
	export_param_container.params = selected_exporter.get_export_params(selected_exporter.get_supported_categories().get(selected_category_id))

	if !export_category_tabbar:
		return
	
	export_category_tabbar.selected_exporter = selected_exporter
		
func get_selected_exporter():
	var ep = Exporter.get_export_plugin(selected_exporter_id)
	return ep

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CommandPalette.register_command(
		'exporter.show_export_window', 
		[],
		func():
			popup_centered()
			)
	
	Exporter.export_plugins_updated.connect(_on_export_plugins_updated)
	
	selected_category_id = 0
	
	pass

func _on_exporter_opt_button_item_selected(index: int) -> void:
	selected_exporter_id = index

func _on_export_param_container_params_updated() -> void:
	for child in Preview_container.get_children():
		Preview_container.remove_child(child)
		child.queue_free()
	
	var export_cat_name = selected_exporter.get_supported_categories().get(selected_category_id)
	var preview_control = selected_exporter.get_preview(export_cat_name, export_param_container.get_parsed_params())
	Preview_container.add_child(preview_control)

func _on_export_category_tabbar_tab_changed(tab: int) -> void:
	selected_category_id = tab

func _on_export_plugins_updated():
	export_param_container.params = selected_exporter.get_export_params(selected_exporter.get_supported_categories().get(selected_category_id))
	export_category_tabbar.selected_exporter = selected_exporter
