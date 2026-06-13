extends Control

const WELCOME_POPUP = preload("uid://jnpmlk0w2y0f")
const NAME_RENAME_POPUP = preload("uid://gthns815f6tg")


func _ready() -> void:
	Settings.load()
	
	Project.create_initail_project()
	
	PluginManager.scan_dir_paths()
	
	PopupManager.register_popup('base.welcome_popup', WELCOME_POPUP)
	PopupManager.register_popup('base.name_rename_popup', NAME_RENAME_POPUP)
	var p = await PopupManager.show_popup('base.welcome_popup')
	
	var w:Window = get_window()
	w.content_scale_factor = 1
	pass
