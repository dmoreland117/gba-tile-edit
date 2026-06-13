class_name PluginConfig


var label:String
var uid:String
var plugin_script:Script


static func load_file(path:String) -> PluginConfig:
	if path.get_extension() != 'cfg':
		printerr(path, ' is not a CFG file.')
		return
	
	var config = ConfigFile.new()
	if config.load(path) != OK:
		return
	
	var p = PluginConfig.new()
	p.label = config.get_value('gbplugin', 'label')
	p.uid = config.get_value('gbplugin', 'uid')
	
	var script_path:String = config.get_value('gbplugin', 'script_path')
	if !script_path:
		return
	
	p.plugin_script = ResourceLoader.load(script_path)
	return p
