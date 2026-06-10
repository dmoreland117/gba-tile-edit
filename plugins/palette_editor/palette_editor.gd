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

func _populate_palette_selector_dropdown():
	if !selected_palette_opt:
		return
	
	selected_palette_opt.clear()
	for palette in Project.palettes.get_palettes():
		selected_palette_opt.add_item(palette.palette_name.capitalize())

#endregion

func _ready() -> void:
	set_palette(palette)
	
	_populate_palette_selector_dropdown()
	if selected_palette_opt:
		selected_palette_opt.select(0)
	
	pass

func _connect_signals():
	Project.palettes.palettes_updated.connect(_on_project_palettes_updated)

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

func _on_project_palettes_updated():
	var last_id = selected_palette_opt.selected
	_populate_palette_selector_dropdown()
	selected_palette_opt.select(last_id)

func _on_selected_palette_opt_item_selected(index: int) -> void:
	set_palette(Project.palettes.get_palette(index))

#endregion
