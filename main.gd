extends Control

# start app > 


func _ready() -> void:
	
	Project.create_initail_project()
	
	Settings.load()
	
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
	Project.load(path)
	
	return true
