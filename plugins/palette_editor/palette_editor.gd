class_name PaletteEditor
extends VBoxContainer

const PALETTE_BANK = preload("uid://c104ob4n4fthl")

@onready var move_up_btn: Button = %move_up_btn
@onready var move_down_btn: Button = %move_down_btn
@onready var palette_grid: VBoxContainer = %palette_grid
@onready var color_picker: ColorPicker = %ColorPicker
@onready var banked_btn: Button = %banked_btn
@onready var fixed_color_picker: FixedColorPicker = %fixed_color_picker
@onready var fixed_mode_btn: Button = %fixed_mode_btn
@onready var palette_name_input: LineEdit = %palette_name_input
@onready var selected_palette_opt: OptionButton = %selected_palette_opt


var banked = false : set=set_banked


func _ready() -> void:
	Context.selected_palette_color_index_changed.connect(_on_context_selected_color_changed)
	Context.selected_palette_bank_changed.connect(_on_context_selected_color_changed)
	
	Project.palettes_updated.connect(_populate_selected_palettes_opt)
	Project.selected_palette_changed.connect(_on_palette_selected)
	_on_palette_selected(Project._palettes[Context.selected_palette_index])
	
	_populate_selected_palettes_opt()
	#_register_commands()

func _on_palette_selected(new_palette):
	Context.selected_palette_index = 0
	Context.selected_palette_bank_index = 0
	
	_on_palette_mode_changed(new_palette.mode)

	_draw_colors(new_palette)
	
	color_picker.color = new_palette.get_color(
		Context.selected_palette_index
	)
	
	palette_name_input.text = new_palette.palette_name
	
	new_palette.palette_updated.connect(_draw_colors.bind(Project.get_selected_palette()))
	new_palette.palette_mode_changed.connect(_on_palette_mode_changed)
	new_palette.fixed_colors_registered.connect(fixed_color_picker.draw_colors)
	new_palette.palette_name_changed.connect(_on_palette_name_changed)

func _populate_selected_palettes_opt():
	selected_palette_opt.clear()
	
	for palette in Project.get_palettes():
		selected_palette_opt.add_item(palette.palette_name)
	
	selected_palette_opt.selected = Context.selected_palette_index

func _draw_colors(palette:GBPaletteData):
	for child in palette_grid.get_children():
		child.queue_free()
	
	if banked:
		var banks = []
		for i in range(0, palette.get_colors().size(), palette.bank_size):
			banks.append(palette.get_colors().slice(i, i + palette.bank_size))
		
		for bank_idx in range(banks.size()):
			var inst:PaletteBankContainer = PALETTE_BANK.instantiate()
			inst.colors = banks[bank_idx]
			inst.bank = bank_idx
			inst.color_selected.connect(select_color)
			
			palette_grid.add_child(inst)
	else:
		var flow_container = HFlowContainer.new()
		flow_container.add_theme_constant_override('h_separation', 8)
		flow_container.add_theme_constant_override('v_separation', 8)
		flow_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		palette_grid.add_child(flow_container)
		for color in palette.get_colors():
			var c = ColorPickerButton.new()
			c.color = color
			c.toggle_mode = true
			c.custom_minimum_size = Vector2(32, 32)
			c.pressed.connect(
			func():
				c.get_popup().hide()
				select_color(0, c.get_index())
			)

			flow_container.add_child(c)
			c.button_pressed = c.get_index() == Project.get_selected_palette().bank_and_idx_to_main_idx(
															Context.selected_palette_bank_index,
															Context.selected_palette_color_index)

func set_banked(new_banked:bool):
	banked = new_banked
	if palette_grid:
		_draw_colors(Project.get_selected_palette())

func select_color(bank:int, idx:int):
	CommandPalette.call_command('selectcolor', idx, bank)

func _on_context_selected_color_changed(idx):
	color_picker.color = Project._palettes[0].get_color(
		Project._palettes[0].bank_and_idx_to_main_idx(
			Context.selected_palette_bank_index,
			Context.selected_palette_color_index
		)
	)
	_draw_colors(Project.get_selected_palette())

func _on_color_picker_color_changed(color: Color) -> void:
	CommandPalette.call_command(
		'setcolor',
		color.r8, color.g8, color.b8,
		Context.selected_palette_color_index,
		Context.selected_palette_bank_index
	)


func _on_add_color_btn_3_pressed() -> void:
	CommandPalette.call_command('addcolor')

func _on_remove_color_btn_4_pressed() -> void:
	CommandPalette.call_command(
		'removecolor', 
		Context.selected_palette_color_index, 
		Context.selected_palette_bank_index
	)

func _on_move_up_btn_pressed() -> void:
	pass # Replace with function body.

func _on_move_down_btn_pressed() -> void:
	pass # Replace with function body.

func _on_banked_btn_toggled(toggled_on: bool) -> void:
	banked = toggled_on

func _on_palette_mode_changed(mode:int):
	if mode == GBPaletteData.PALETTE_MODE_FIXED:
		color_picker.hide()
		fixed_color_picker.show()
	else:
		color_picker.show()
		fixed_color_picker.hide()

func _on_fixed_mode_btn_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Project.get_selected_palette().mode = GBPaletteData.PALETTE_MODE_FIXED
		return
	
	Project.get_selected_palette().mode = GBPaletteData.PALETTE_MODE_RGB

func _on_fixed_color_picker_selected_color_changed(idx: Variant) -> void:
	Project.palette.set_color(
		Project.palette.bank_and_idx_to_main_idx(
			Context.selected_palette_bank_index,
			Context.selected_palette_color_index,
		),
		idx
	)

func _on_palette_name_changed(new_name:String):
	palette_name_input.text = new_name

func _on_palette_name_input_text_submitted(new_text: String) -> void:
	Project.get_selected_palette().set_palette_name(new_text)
	selected_palette_opt.set_item_text(Context.selected_palette_index, new_text)

func _on_selected_palette_opt_item_selected(index: int) -> void:
	Project.select_palette(index)
