extends Control

# start app > 


func _ready() -> void:
	Project.create_initail_project()
	
	Settings.load()
	
	var file_popup_menu = PopupMenu.new()
	file_popup_menu.name = 'File'
	file_popup_menu.add_item('Open', -1, KEY_MASK_CTRL | KEY_O)
	file_popup_menu.add_item('Save', -1, KEY_MASK_CTRL | KEY_S)
	file_popup_menu.add_item('Save As', -1, KEY_MASK_CTRL | KEY_MASK_ALT | KEY_S)
	
	file_popup_menu.id_pressed.connect(
		func(id):
			match id:
				0:
					CommandPalette.call_command('load')
				1:
					CommandPalette.call_command('save')
				2:
					CommandPalette.call_command('saveas')
	)
	
	var edit_popup_menu = PopupMenu.new()
	edit_popup_menu.name = 'Edit'
	edit_popup_menu.add_item('Create Palette', -1, KEY_MASK_CTRL | KEY_MASK_SHIFT | KEY_P)
	edit_popup_menu.add_item('Create Tileset', -1, KEY_MASK_CTRL | KEY_MASK_SHIFT | KEY_T)
	edit_popup_menu.add_item('Settings', -1, KEY_MASK_CTRL | KEY_COMMA)
	
	edit_popup_menu.id_pressed.connect(
		func(id):
			match id:
				0:
					CommandPalette.call_command('addpalette', 'test', GBPaletteData.PALETTE_MODE_FIXED)
				1:
					Popups.show_create_tileset_window()
				2:
					Popups.show_settings_window()
	)
	
	Ui.get_menu_bar().add_child(file_popup_menu)
	Ui.get_menu_bar().add_child(edit_popup_menu)
	
	CommandPalette.register_command(
		'save',
		[],
		save_proj
	)
	CommandPalette.register_command(
		'saveas',
		[],
		save_proj_as
	)
	CommandPalette.register_command(
		'load',
		[],
		load_proj
	)
	
	var save_btn = Button.new()
	save_btn.text = 'Save Project'
	save_btn.theme_type_variation = 'primary_btn'
	save_btn.pressed.connect(
		func():
			CommandPalette.call_command('save')
	)
	
	Ui.get_container(Ui.TOP_RIGHT_CONTIANER).add_child(save_btn)
	
	PluginManager.scan_dir_paths()
	
	#PluginManager.load_plugin("res://plugin_test.cfg")
	#PluginManager.load_plugin("res://plugins/tile_editor/tile_editor_plugin.gd")
	#PluginManager.load_plugin("res://plugins/exporter/exporter_ui_plugin.gd")
	#PluginManager.load_plugin("res://plugins/tile_viewer_selector/tile_viewer_plugin.gd")
	#PluginManager.load_plugin("res://plugins/map_editor/map_edit_plugin.gd")
	
	Popups.show_welcome_popup()
	
	var w:Window = get_window()
	w.content_scale_factor = 1
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("show_cmd_palette"):
		Popups.show_command_palette()
	if Input.is_action_just_pressed("add_palette_color"):
		Project.palette.add_color()

func save_proj():
	var path
	if Project.last_save_path.is_empty():
		path = await Popups.show_save_file_popup(['*.gbproj'])
	else:
		path = Project.last_save_path
	
	#Project.save(path)
	ProjectSaver.save_project_file(path)
	
	return true

func save_proj_as():
	var path = await Popups.show_save_file_popup(['*.gbproj'])
	Project.save(path)
	
	return true

func load_proj():
	var path = await Popups.show_open_file_popup(['*.gbproj'])
	ProjectSaver.load_project_file(path)
	
	return true
