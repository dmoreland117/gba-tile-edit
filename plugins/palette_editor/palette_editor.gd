class_name PaletteEditor
extends VBoxContainer

const PALETTE_BANK = preload("uid://c104ob4n4fthl")

enum PaletteMode {
	NORMAL,
	BANKED
}

@onready var export_palette_btn: Button = %export_palette_btn
@onready var move_up_btn: Button = %move_up_btn
@onready var move_down_btn: Button = %move_down_btn
@onready var palette_grid: VBoxContainer = %palette_grid
@onready var palette_mode_opt: OptionButton = %palette_mode_opt
@onready var color_picker: ColorPicker = %ColorPicker


var mode:PaletteMode = PaletteMode.NORMAL : set=set_palette_mode


func _ready() -> void:
	_draw_colors()
	
	color_picker.color = Project.palette.get_color(
		Context.selected_palette_idx
	)
	
	Context.selected_palette_idx_changed.connect(_on_context_selected_color_changed)
	Project.palette.palette_updated.connect(_draw_colors)
	
	palette_mode_opt.select(mode)
	
	#_register_commands()

func _draw_colors():
	for child in palette_grid.get_children():
		child.queue_free()
	
	if mode == PaletteMode.BANKED:
		var palette = Project.palette
		var banks = []
		for i in range(0, palette.get_colors().size(), palette.BANK_SIZE):
			banks.append(palette.get_colors().slice(i, i + palette.BANK_SIZE))
		
		for bank_idx in range(banks.size()):
			var inst:PaletteBankContainer = PALETTE_BANK.instantiate()
			inst.colors = banks[bank_idx]
			inst.bank = bank_idx
			inst.color_selected.connect(select_color)
			
			palette_grid.add_child(inst)

	if mode == PaletteMode.NORMAL:
		var flow_container = HFlowContainer.new()
		flow_container.add_theme_constant_override('h_separation', 8)
		flow_container.add_theme_constant_override('v_separation', 8)
		flow_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		palette_grid.add_child(flow_container)
		for color in Project.palette.get_colors():
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
			c.button_pressed = c.get_index() == GBPalette.bank_and_idx_to_main_idx(Context.selected_palette_bank, Context.selected_palette_idx)

func set_palette_mode(new_mode:PaletteMode):
	mode = new_mode
	if palette_grid:
		_draw_colors()

func select_color(bank:int, idx:int):
	CommandPalette.call_command('selectcolor', idx, bank)

func _on_palette_mode_opt_item_selected(index: int) -> void:
	mode = index

func _on_context_selected_color_changed(idx):
	color_picker.color = Project.palette.get_color(
		GBPalette.bank_and_idx_to_main_idx(
			Context.selected_palette_bank,
			Context.selected_palette_idx
		)
	)
	_draw_colors()

func _on_color_picker_color_changed(color: Color) -> void:
	CommandPalette.call_command(
		'setcolor',
		color.r8, color.g8, color.b8,
		Context.selected_palette_idx,
		Context.selected_palette_bank
	)

func _on_import_palette_btn_pressed() -> void:
	pass # Replace with function body.

func _on_export_palette_btn_pressed() -> void:
	pass # Replace with function body.

func _on_add_color_btn_3_pressed() -> void:
	CommandPalette.call_command('addcolor')

func _on_remove_color_btn_4_pressed() -> void:
	CommandPalette.call_command(
		'removecolor', 
		Context.selected_palette_idx, 
		Context.selected_palette_bank
	)

func _on_move_up_btn_pressed() -> void:
	pass # Replace with function body.

func _on_move_down_btn_pressed() -> void:
	pass # Replace with function body.
