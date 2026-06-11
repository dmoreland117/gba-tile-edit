class_name PaletteEditor
extends ScrollContainer


signal palette_id_changed(id:int)

@onready var move_up_btn: Button = %move_up_btn
@onready var move_down_btn: Button = %move_down_btn
@onready var selected_palette_opt: OptionButton = %selected_palette_opt

@onready var color_button_hflow: HFlowContainer = %color_button_hflow
@onready var color_picker: ColorPicker = %ColorPicker

var palette:GBPaletteData : get=get_palette

var selected_palette_id:int : set=set_palette_id
var selected_color_id:int : set=set_color_id


func set_color_id(id:int):
	selected_color_id = id
	
	if !palette:
		return
	
	color_picker.color = palette.get_color(id)
	
	_draw_palette_colors()

func set_palette_id(id:int):
	selected_palette_id = id
	
	if !palette:
		return
	
	palette.palette_updated.connect(_on_palette_updated)
	palette.palette_color_added.connect(_on_palette_color_added)
	palette.palette_color_updated.connect(_on_palette_color_updated)
	palette.palette_color_removed.connect(_on_palette_color_removed)
	palette.palette_name_changed.connect(_on_palette_name_changed)
	
	_draw_palette_colors()
	
	palette_id_changed.emit(id)

func get_palette() -> GBPaletteData:
	return Project.palettes.get_palette(selected_palette_id)

func select_color_id(id:int) -> void:
	pass

func _populate_selected_palette_opt():
	if !selected_palette_opt:
		return
	
	selected_palette_opt.clear()
	
	for pal in Project.palettes.get_palettes():
		selected_palette_opt.add_item(pal.palette_name)

	selected_palette_opt.select(selected_palette_id)

func _draw_palette_colors() -> void:
	for child in color_button_hflow.get_children():
		color_button_hflow.remove_child(child)
		child.queue_free()
	
	for color in palette.get_colors():
		var cb = ColorPickerButton.new()
		cb.color = color
		cb.custom_minimum_size = Vector2(32, 32)
		
		
		
		color_button_hflow.add_child(cb)
		
		cb.button_pressed = cb.get_index() == selected_color_id
		
		cb.pressed.connect(
			func():
				cb.get_popup().hide()
				_on_palette_color_pressed(cb.get_index())
		)

func _ready() -> void:
	selected_color_id = 0
	selected_palette_id = 0
	
	Project.palettes.palettes_updated.connect(
		func():
			_populate_selected_palette_opt()
			selected_palette_id = selected_palette_id
	)
	
	_populate_selected_palette_opt()

func _on_palette_updated():
	if palette._colors.size() < selected_color_id:
		selected_color_id = clamp(palette._colors.size() - 1, 0, palette._colors.size())
		return
	
	_draw_palette_colors()
	
func _on_palette_color_added():
	var cb = ColorPickerButton.new()
	cb.color = palette._colors.back()
	cb.custom_minimum_size = Vector2(32, 32)
	
	color_button_hflow.add_child(cb)
	
	cb.button_pressed = cb.get_index() == selected_color_id
	
	cb.pressed.connect(
		func():
			cb.get_popup().hide()
			_on_palette_color_pressed(cb.get_index())
	)
	
func _on_palette_color_updated(id:int, color:Color):
	var cb = color_button_hflow.get_child(id)
	if !cb:
		return
	
	cb.color = color
	
func _on_palette_color_removed(id:int):
	_draw_palette_colors()
	
func _on_palette_name_changed(new_name:String):
	selected_palette_opt.set_item_text(selected_palette_id, new_name)

func _on_palette_color_pressed(id:int):
	selected_color_id = id

func _on_add_color_btn_3_pressed() -> void:
	palette.add_color()

func _on_remove_color_btn_4_pressed() -> void:
	pass # Replace with function body.

func _on_move_up_btn_pressed() -> void:
	var prev_color = palette.get_color(selected_color_id)
	
	if (selected_color_id + 1) >= palette._colors.size():
		return
	
	var new_color = palette.get_color(selected_color_id + 1)
	
	palette.set_color(selected_color_id, new_color)
	palette.set_color(selected_color_id + 1, prev_color)
	
	selected_color_id = selected_color_id

func _on_move_down_btn_pressed() -> void:
	var prev_color = palette.get_color(selected_color_id)
	
	if (selected_color_id - 1) < 0:
		return
	
	var new_color = palette.get_color(selected_color_id - 1)
	
	palette.set_color(selected_color_id, new_color)
	palette.set_color(selected_color_id - 1, prev_color)
	
	selected_color_id = selected_color_id

func _on_color_picker_color_changed(color: Color) -> void:
	if !palette:
		return
	
	palette.set_color(selected_color_id, color)

func _on_selected_palette_opt_item_selected(index: int) -> void:
	selected_palette_id = index

func _on_rename_palette_btn_pressed() -> void:
	var new_name = await Popups.show_name_rename_popup('Rename Palette', palette.palette_name)
	palette.set_palette_name(new_name)

func _on_add_palette_btn_pressed() -> void:
	var new_name = await Popups.show_name_rename_popup('Name new Palette', 'Untitled', 'Create')
	var new_pal = RGBPaletteData.new()
	new_pal.set_palette_name(new_name)
	new_pal.add_color()
	
	Project.palettes.add_palette(new_pal)

func _on_remove_palette_btn_pressed() -> void:
	Project.palettes.remove_palette(selected_palette_id)
	
	var palettes_size = Project.palettes.get_palettes().size()
	if selected_palette_id >= palettes_size:
		selected_palette_id = palettes_size - 1
