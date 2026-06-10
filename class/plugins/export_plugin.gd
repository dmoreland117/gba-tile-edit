@abstract
class_name ExportPlugin


signal export_params_update_requested()

@abstract
func get_exporter_name() -> String
@abstract
func get_supported_types() -> Array[String]
@abstract
func get_export_file_filters() -> Array[String]
@abstract
func get_export_params(type:String) -> Dictionary
@abstract
func export(path:String, type:String, params) -> bool
@abstract
func get_preview(type:String, params) -> Control

func request_update_export_params() -> void:
	export_params_update_requested.emit()
