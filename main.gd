extends Control

const NES_PALETTE:Array[Color] = [
	Color(124/255.0, 124/255.0, 124/255.0),
	Color(0/255.0, 0/255.0, 252/255.0),
	Color(0/255.0, 0/255.0, 188/255.0),
	Color(68/255.0, 40/255.0, 188/255.0),
	Color(148/255.0, 0/255.0, 132/255.0),
	Color(168/255.0, 0/255.0, 32/255.0),
	Color(168/255.0, 16/255.0, 0/255.0),
	Color(136/255.0, 20/255.0, 0/255.0),
	Color(80/255.0, 48/255.0, 0/255.0),
	Color(0/255.0, 120/255.0, 0/255.0),
	Color(0/255.0, 104/255.0, 0/255.0),
	Color(0/255.0, 88/255.0, 0/255.0),
	Color(0/255.0, 64/255.0, 88/255.0),
	Color(0/255.0, 0/255.0, 0/255.0),
	Color(0/255.0, 0/255.0, 0/255.0),
	Color(0/255.0, 0/255.0, 0/255.0),
	Color(188/255.0, 188/255.0, 188/255.0),
	Color(0/255.0, 120/255.0, 248/255.0),
	Color(0/255.0, 88/255.0, 248/255.0),
	Color(104/255.0, 68/255.0, 252/255.0),
	Color(216/255.0, 0/255.0, 204/255.0),
	Color(228/255.0, 0/255.0, 88/255.0),
	Color(248/255.0, 56/255.0, 0/255.0),
	Color(228/255.0, 92/255.0, 16/255.0),
	Color(172/255.0, 124/255.0, 0/255.0),
	Color(0/255.0, 184/255.0, 0/255.0),
	Color(0/255.0, 168/255.0, 0/255.0),
	Color(0/255.0, 168/255.0, 68/255.0),
	Color(0/255.0, 136/255.0, 136/255.0),
	Color(0/255.0, 0/255.0, 0/255.0),
	Color(0/255.0, 0/255.0, 0/255.0),
	Color(0/255.0, 0/255.0, 0/255.0),
	Color(248/255.0, 248/255.0, 248/255.0),
	Color(60/255.0, 188/255.0, 252/255.0),
	Color(104/255.0, 136/255.0, 252/255.0),
	Color(152/255.0, 120/255.0, 248/255.0),
	Color(248/255.0, 120/255.0, 248/255.0),
	Color(248/255.0, 88/255.0, 152/255.0),
	Color(248/255.0, 120/255.0, 88/255.0),
	Color(252/255.0, 160/255.0, 68/255.0),
	Color(248/255.0, 184/255.0, 0/255.0),
	Color(184/255.0, 248/255.0, 24/255.0),
	Color(88/255.0, 216/255.0, 84/255.0),
	Color(88/255.0, 248/255.0, 152/255.0),
	Color(0/255.0, 232/255.0, 216/255.0),
	Color(120/255.0, 120/255.0, 120/255.0),
	Color(0/255.0, 0/255.0, 0/255.0),
	Color(0/255.0, 0/255.0, 0/255.0),
	Color(252/255.0, 252/255.0, 252/255.0),
	Color(164/255.0, 228/255.0, 252/255.0),
	Color(184/255.0, 184/255.0, 248/255.0),
	Color(216/255.0, 184/255.0, 248/255.0),
	Color(248/255.0, 184/255.0, 248/255.0),
	Color(248/255.0, 164/255.0, 192/255.0),
	Color(240/255.0, 208/255.0, 176/255.0),
	Color(252/255.0, 224/255.0, 168/255.0),
	Color(248/255.0, 216/255.0, 120/255.0),
	Color(216/255.0, 248/255.0, 120/255.0),
	Color(184/255.0, 248/255.0, 184/255.0),
	Color(184/255.0, 248/255.0, 216/255.0),
	Color(0/255.0, 252/255.0, 252/255.0),
	Color(248/255.0, 216/255.0, 248/255.0),
	Color(0/255.0, 0/255.0, 0/255.0),
	Color(0/255.0, 0/255.0, 0/255.0),
]



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
	
	PluginManager.load_plugin("res://plugins/palette_editor/color_palette_and_picker.gd")
	PluginManager.load_plugin("res://plugins/tile_editor/tile_editor_plugin.gd")
	PluginManager.load_plugin("res://plugins/exporter/exporter_ui_plugin.gd")
	PluginManager.load_plugin("res://plugins/tile_viewer_selector/tile_viewer_plugin.gd")
	PluginManager.load_plugin("res://plugins/map_editor/map_edit_plugin.gd")
	
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
	
	Project.save(path)
	
	return true

func save_proj_as():
	var path = await Popups.show_save_file_popup(['*.gbproj'])
	Project.save(path)
	
	return true

func load_proj():
	var path = await Popups.show_open_file_popup(['*.gbproj'])
	Project.load(path)
	
	return true
