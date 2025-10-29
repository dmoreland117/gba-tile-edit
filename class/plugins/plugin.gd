class_name GBEditPlugin
extends Node


func register_command(cmd_name:String, cmd_args:Array[Dictionary], cmd_callback:Callable):
	CommandPalette.register_command(cmd_name, cmd_args, cmd_callback)

func register_exporter_plugin(plugin:ExportPlugin):
	Exporter.register_export_plugin(plugin)

func register_system_preset(preset:Dictionary):
	PluginManager.register_system_preset(preset)
