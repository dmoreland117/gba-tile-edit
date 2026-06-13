extends Node


signal export_plugins_updated()

var _export_plugins:Array[ExportPlugin] = []


func register_export_plugin(plugin:ExportPlugin):
	_export_plugins.append(plugin)
	export_plugins_updated.emit()

func remove_export_plugin(plugin:ExportPlugin):
	var plugin_id = _export_plugins.find(plugin)
	var plugin_inst = _export_plugins.get(plugin_id)
	
	_export_plugins.remove_at(plugin_id)
	export_plugins_updated.emit()

func get_exporter_names() -> Array[String]:
	if _export_plugins.is_empty():
		return []
	
	var ret:Array[String] = []
	
	for plugin in _export_plugins:
		ret.append(plugin.get_exporter_name())
	
	return ret

func get_export_plugin(id:int) -> ExportPlugin:
	return _export_plugins.get(id)
	

func export(plugin_id:int, path:String, category:String, params:Dictionary[String, Dictionary]):
	var e = _export_plugins.get(plugin_id)
	
	if e:
		e.export(path, category, params)
