extends GBEditPlugin

const TILE_EDITOR = preload("uid://btlvl3adq1x6g")

var tile_editor:TileEditor

func _enter_tree() -> void:
	_add_settings()
	tile_editor = TILE_EDITOR.instantiate()
	Ui.get_container(Ui.MAIN_CONTAINER).add_child(tile_editor)
	
	var tm = Settings.get_setting('tile_mode', 'tile_editor')
	tile_editor.mode = tm
	var sg = Settings.get_setting('show_grid', 'tile_editor', '.', false)
	tile_editor.show_grid = sg
	
	_register_commands()

func _register_commands():
	CommandPalette.register_command(
		'tileeditor:setpalettebank',
		[
			{
				'name': 'bank',
				'type': TYPE_INT
			}
		],
		set_selected_bank
	)

func _add_settings():
	if !Settings.has_setting('show_grid', 'tile_editor'):
		Settings.set_setting(true, 'show_grid', 'tile_editor')
	if !Settings.has_setting('tile_mode', 'tile_editor'):
		Settings.set_setting(1, 'tile_mode', 'tile_editor')
func set_selected_bank(bank:int):
	Context.selected_palette_bank = bank
