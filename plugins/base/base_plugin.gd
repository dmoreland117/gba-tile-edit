extends GBEditPlugin

const SETTINGS_POPUP = preload("uid://8efh3ipu4r1e")

const PALETTE_EDITOR = preload('uid://w3ut3j5wah08')
const TILE_EDITOR = preload('uid://btlvl3adq1x6g')

var palette_editor_instance:PaletteEditor
var tile_editor_instance:TileEditor


func _enter_tree() -> void:
	register_exporter_plugin(GBACHeaderExporter.new())
	register_exporter_plugin(CX16.new())
	
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
	
	#init palette editor
	palette_editor_instance = PALETTE_EDITOR.instantiate()
	Ui.get_container(Ui.LEFT_CONTAINER).add_child(palette_editor_instance)
	
	tile_editor_instance = TILE_EDITOR.instantiate()
	tile_editor_instance.palette_editor = palette_editor_instance
	Ui.get_container(Ui.MAIN_CONTAINER).add_child(tile_editor_instance)
	
	_register_commands()
	pass

func _register_commands():
	register_command('newpalette', [{'name': 'pal_name', 'type': TYPE_STRING}], add_palette)

func add_palette(pal_name:String):
	var pal = RGBPaletteData.new()
	pal.set_palette_name(pal_name)
	Project.palettes.add_palette(pal)

func save_proj():
	var path
	if Project.last_save_path.is_empty():
		var fd = PopupManager.show_file_dialouge(FileDialog.FILE_MODE_SAVE_FILE, ['*.gbproj'])
		path = await fd.file_selected
	else:
		path = Project.last_save_path
	
	ProjectSaver.save_project_file(path)
	
	return true

func save_proj_as():
	var fd = PopupManager.show_file_dialouge(FileDialog.FILE_MODE_SAVE_FILE, ['*.gbproj'])
	var path = await fd.file_selected
	
	ProjectSaver.save_project_file(path)
	
	return true

func load_proj():
	var fd = PopupManager.show_file_dialouge(FileDialog.FILE_MODE_OPEN_FILE, ['*.gbproj'])
	var path = await fd.file_selected
	
	ProjectSaver.load_project_file(path)
	
	return true
