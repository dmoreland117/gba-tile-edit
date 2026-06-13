extends Control


func _ready() -> void:
	Settings.load()
	
	Project.create_initail_project()
	
	PluginManager.scan_dir_paths()
	
	Popups.show_welcome_popup()
	
	var w:Window = get_window()
	w.content_scale_factor = 1
	pass
