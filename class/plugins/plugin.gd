class_name GBEditPlugin
extends Node


func register_command(cmd_name:String, cmd_args:Array[Dictionary], cmd_callback:Callable):
	CommandPalette.register_command(cmd_name, cmd_args, cmd_callback)

func register_exporter_plugin(plugin:ExportPlugin):
	Exporter.register_export_plugin(plugin)

func register_system_preset(preset:Dictionary):
	PluginManager.register_system_preset(preset)

func instance_scene_at_path(path:String, script_path:String):
	if !FileAccess.file_exists(path):
		return
	if !FileAccess.file_exists(script_path):
		return
	
	var scene = ResourceLoader.load(path)
	if !scene:
		return
	
	var scene_instance:Node = scene.instantiate()
	
	var script:Script = ResourceLoader.load(script_path)
	if !script:
		return
	
	scene_instance.set_script(script)
	
	return scene_instance
