class_name PaletteEditor
extends ScrollContainer

signal color_prssed(id:int)

@onready var move_up_btn: Button = %move_up_btn
@onready var move_down_btn: Button = %move_down_btn
@onready var banked_btn: Button = %banked_btn
@onready var selected_palette_opt: OptionButton = %selected_palette_opt

@onready var color_button_hflow: HFlowContainer = %color_button_hflow
@onready var color_picker: ColorPicker = %ColorPicker

var selected_color_id:int = -1 : set=select_color_id
var banked:bool = false
var bank_size:int = 16
var palette:GBPaletteData : set=set_palette

var _hovered_color_id:int = 0
var _mouse_inside_panel:bool = false

#region get - sets

func select_color_id(id:int) -> void:
	selected_color_id = id
	if !color_picker:
		return
	
	if id == -1:
		color_picker.color = Color.BLACK
		return
	
	if palette:
		color_picker.color = palette.get_color(id)
		return
	
	color_picker.color = Color.BLACK

func set_palette(new_palette:GBPaletteData) -> void:
	palette = new_palette
	
	if color_button_hflow:
		_clear_color_hflow()
	
	if !palette:
		selected_color_id = -1
		return
	
	_draw_palette_colors()
	_connect_new_palette_signals()
	
	if palette.get_colors().size() > 0:
		selected_color_id = 0
	
	#if palette is FixedPaletteData:
		#fixed_color_picker.show()
		#fixed_color_picker.colors = palette.get_fixed_colors()
		#color_picker.hide()	
#endregion

#region privates

func _connect_new_palette_signals():
	palette.palette_updated.connect(
		func():
			_clear_color_hflow()
			_draw_palette_colors()
	)
	palette.palette_color_updated.connect(
		func(id, color):
			if !color_button_hflow:
				return
			
			var cr = color_button_hflow.get_child(id)
			if cr is ColorRect:
				cr.color = color
	)

func _clear_color_hflow() -> void:
	for child in color_button_hflow.get_children():
		color_button_hflow.remove_child(child)
		child.queue_free()

func _draw_palette_colors() -> void:
	for color in palette.get_colors():
		var cr := ColorRect.new()
		cr.color = color
		cr.custom_minimum_size = Vector2(32, 32)
		cr.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		cr.mouse_filter = Control.MOUSE_FILTER_PASS
		color_button_hflow.add_child(cr)
		
		cr.mouse_entered.connect(
			func():
				_hovered_color_id = cr.get_index()
		)

#endregion

func _ready() -> void:
	set_palette(palette)
	
	pass

func _input(event: InputEvent) -> void:
	if !_mouse_inside_panel:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			selected_color_id = _hovered_color_id
			Context.selected_palette_color_index = selected_color_id

#region signals

func _on_color_picker_color_changed(color: Color) -> void:
	if !palette or selected_color_id == -1:
		return
	
	palette.set_color(selected_color_id, color)

func _on_color_button_hflow_mouse_entered() -> void:
	_mouse_inside_panel = true

func _on_color_button_hflow_mouse_exited() -> void:
	_mouse_inside_panel = false

func _on_add_color_btn_3_pressed() -> void:
	if !palette:
		return
	
	palette.add_color()
	if Input.is_action_pressed('btn_mod'):
		var col = palette.get_color(Context.selected_palette_color_index)
		if col:
			palette.set_color(-1, col)

func _on_fixed_color_picker_color_changed(idx: Variant) -> void:
	if !palette:
		return
	
	if palette is not FixedPaletteData:
		return
	
	palette.set_color_indexed(selected_color_id, idx)

#endregion

#func _ready() -> void:
	#Context.selected_palette_color_index_changed.connect(_on_context_selected_color_changed)
	#Context.selected_palette_bank_changed.connect(_on_context_selected_color_changed)
	#
	#Project.palettes_updated.connect(_populate_selected_palettes_opt)
	#Project.selected_palette_changed.connect(_on_palette_selected)
	#_on_palette_selected(Project._palettes[Context.selected_palette_index])
	#
	#_populate_selected_palettes_opt()
	##_register_commands()
#
#func _on_palette_selected(new_palette):
	#Context.selected_palette_index = 0
	#Context.selected_palette_bank_index = 0
	#
	#_on_palette_mode_changed(new_palette.mode)
#
	#_draw_colors(new_palette)
	#
	#color_picker.color = new_palette.get_color(
		#Context.selected_palette_index
	#)
	#
	#palette_name_input.text = new_palette.palette_name
	#
	#new_palette.palette_updated.connect(_draw_colors.bind(Project.get_selected_palette()))
	#new_palette.palette_mode_changed.connect(_on_palette_mode_changed)
	#new_palette.fixed_colors_registered.connect(fixed_color_picker.draw_colors)
	#new_palette.palette_name_changed.connect(_on_palette_name_changed)
#
#func _populate_selected_palettes_opt():
	#selected_palette_opt.clear()
	#
	#for palette in Project.get_palettes():
		#selected_palette_opt.add_item(palette.palette_name)
	#
	#selected_palette_opt.selected = Context.selected_palette_index
#
#func _draw_colors(palette:GBPaletteData):
	#for child in palette_grid.get_children():
		#child.queue_free()
	#
	#if banked:
		#var banks = []
		#for i in range(0, palette.get_colors().size(), palette.bank_size):
			#banks.append(palette.get_colors().slice(i, i + palette.bank_size))
		#
		#for bank_idx in range(banks.size()):
			#var inst:PaletteBankContainer = PALETTE_BANK.instantiate()
			#inst.colors = banks[bank_idx]
			#inst.bank = bank_idx
			#inst.color_selected.connect(select_color)
			#
			#palette_grid.add_child(inst)
	#else:
		#var flow_container = HFlowContainer.new()
		#flow_container.add_theme_constant_override('h_separation', 8)
		#flow_container.add_theme_constant_override('v_separation', 8)
		#flow_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		#palette_grid.add_child(flow_container)
		#for color in palette.get_colors():
			#var c = ColorPickerButton.new()
			#c.color = color
			#c.toggle_mode = true
			#c.custom_minimum_size = Vector2(32, 32)
			#c.pressed.connect(
			#func():
				#c.get_popup().hide()
				#select_color(0, c.get_index())
			#)
#
			#flow_container.add_child(c)
			#c.button_pressed = c.get_index() == Project.get_selected_palette().bank_and_idx_to_main_idx(
															#Context.selected_palette_bank_index,
															#Context.selected_palette_color_index)
#
#func set_banked(new_banked:bool):
	#banked = new_banked
	#if palette_grid:
		#_draw_colors(Project.get_selected_palette())
#
#func select_color(bank:int, idx:int):
	#CommandPalette.call_command('selectcolor', idx, bank)
#
#func _on_context_selected_color_changed(idx):
	#color_picker.color = Project._palettes[0].get_color(
		#Project._palettes[0].bank_and_idx_to_main_idx(
			#Context.selected_palette_bank_index,
			#Context.selected_palette_color_index
		#)
	#)
	#_draw_colors(Project.get_selected_palette())
#
#func _on_color_picker_color_changed(color: Color) -> void:
	#CommandPalette.call_command(
		#'setcolor',
		#color.r8, color.g8, color.b8,
		#Context.selected_palette_color_index,
		#Context.selected_palette_bank_index
	#)
#
#
#func _on_add_color_btn_3_pressed() -> void:
	#CommandPalette.call_command('addcolor')
#
#func _on_remove_color_btn_4_pressed() -> void:
	#CommandPalette.call_command(
		#'removecolor', 
		#Context.selected_palette_color_index, 
		#Context.selected_palette_bank_index
	#)
#
#func _on_move_up_btn_pressed() -> void:
	#pass # Replace with function body.
#
#func _on_move_down_btn_pressed() -> void:
	#pass # Replace with function body.
#
#func _on_banked_btn_toggled(toggled_on: bool) -> void:
	#banked = toggled_on
#
#func _on_palette_mode_changed(mode:int):
	#if mode == GBPaletteData.PALETTE_MODE_FIXED:
		#color_picker.hide()
		#fixed_color_picker.show()
	#else:
		#color_picker.show()
		#fixed_color_picker.hide()
#
#func _on_fixed_mode_btn_toggled(toggled_on: bool) -> void:
	#if toggled_on:
		#Project.get_selected_palette().mode = GBPaletteData.PALETTE_MODE_FIXED
		#return
	#
	#Project.get_selected_palette().mode = GBPaletteData.PALETTE_MODE_RGB
#
#func _on_fixed_color_picker_selected_color_changed(idx: Variant) -> void:
	#Project.palette.set_color(
		#Project.palette.bank_and_idx_to_main_idx(
			#Context.selected_palette_bank_index,
			#Context.selected_palette_color_index,
		#),
		#idx
	#)
#
#func _on_palette_name_changed(new_name:String):
	#palette_name_input.text = new_name
#
#func _on_palette_name_input_text_submitted(new_text: String) -> void:
	#Project.get_selected_palette().set_palette_name(new_text)
	#selected_palette_opt.set_item_text(Context.selected_palette_index, new_text)
#
#func _on_selected_palette_opt_item_selected(index: int) -> void:
	#Project.select_palette(index)
