extends GBEditPlugin

const PALETTE_EDITOR = preload("uid://w3ut3j5wah08")

var palette_editor:PaletteEditor

func _enter_tree() -> void:
	_register_commands()
	
	Project.palettes_updated.connect(
		func():
			palette_editor.palette = Project.get_selected_palette()
	)
	
	palette_editor = PALETTE_EDITOR.instantiate()
	Ui.get_container(Ui.LEFT_CONTAINER).add_child(palette_editor)
	palette_editor.palette = Project.get_selected_palette()

func _exit_tree() -> void:
	pass

func _register_commands():
	register_command(
		'setcolor',
		[
			{
				'name': 'r',
				'type': TYPE_INT
			},
			{
				'name': 'g',
				'type': TYPE_INT
			},{
				'name': 'b',
				'type': TYPE_INT
			},
			{
				'name': 'id',
				'type': TYPE_INT
			},
			{
				'name': 'bank',
				'type': TYPE_INT
			},
		],
		_set_color
	)
	register_command(
		'addcolor',
		[],
		_add_color
	)
	register_command(
		'removecolor',
		[
			{
				'name': 'id',
				'type': TYPE_INT
			},
			{
				'name': 'bank',
				'type': TYPE_INT
			},
		],
		_remove_color
	)
	register_command(
		'selectcolor',
		[
			{
				'name': 'id',
				'type': TYPE_INT
			},
			{
				'name': 'bank',
				'type': TYPE_INT
			},
		],
		_select_color
	)
	register_command(
		'setpalettemode',
		[
			{
				'name': 'mode',
				'type': TYPE_STRING
			},
		],
		_set_palette_mode
	)
	register_command(
		'addpalette',
		[
			{
				'name': 'name',
				'type': TYPE_STRING
			},
			{
				'name': 'mode',
				'type': TYPE_INT
			}
		],
		_add_palette
	)
	
func _set_palette_mode(mode:String):
	if mode == 'n':
		palette_editor.mode = palette_editor.PaletteMode.NORMAL
	if mode == 'b':
		palette_editor.mode = palette_editor.PaletteMode.BANKED
	
	return true

func _select_color(id:int, bank:int):
	Context.selected_palette_color_index = id
	Context.selected_palette_bank_index = bank
	
	return true

func _remove_color(id:int, bank:int):
	Project.get_selected_palette().remove_color(
		Project.get_selected_palette().bank_and_idx_to_main_idx(
			bank, id
		)
	)
	
	return true

func _add_color():
	Project.get_selected_palette().add_color()
	
	return true

func _set_color(r:int, g:int, b:int, id:int = -1, bank:int = -1):
	var c = Color()
	c.r8 = r
	c.g8 = g
	c.b8 = b
	
	Project.get_selected_palette().set_color(
		Project.get_selected_palette().bank_and_idx_to_main_idx(bank, id),
		c
	)
	
	return true

func _add_palette(name:String, mode:int):
	var data = RGBPaletteData.new()
	data.palette_name = name
	data.mode = mode
	Project.add_palette(data)
	
	return true
