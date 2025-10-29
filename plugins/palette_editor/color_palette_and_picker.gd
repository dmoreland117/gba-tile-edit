extends GBEditPlugin

const PALETTE_EDITOR = preload("uid://w3ut3j5wah08")

var palette_editor:PaletteEditor

func _enter_tree() -> void:
	_register_commands()
	
	palette_editor = PALETTE_EDITOR.instantiate()
	Ui.get_container(Ui.LEFT_CONTAINER).add_child(palette_editor)

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
	
func _set_palette_mode(mode:String):
	if mode == 'n':
		palette_editor.mode = palette_editor.PaletteMode.NORMAL
	if mode == 'b':
		palette_editor.mode = palette_editor.PaletteMode.BANKED

func _select_color(id:int, bank:int):
	Project.palette.selected_palette_idx = id
	Project.palette.selected_palette_bank = bank

func _remove_color(id:int, bank:int):
	Project.palette.remove_color(
		GBPalette.bank_and_idx_to_main_idx(
			bank, id
		)
	)

func _add_color():
	Project.palette.add_color()

func _set_color(r:int, g:int, b:int, id:int = -1, bank:int = -1):
	var c = Color()
	c.r8 = r
	c.g8 = g
	c.b8 = b
	
	Project.palette.set_color(
		GBPalette.bank_and_idx_to_main_idx(bank, id),
		c
	)
	
	return true
