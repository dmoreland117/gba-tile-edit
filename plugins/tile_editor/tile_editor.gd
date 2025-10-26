class_name TileEditor
extends VBoxContainer


const TILE_TEXTURE = preload("uid://r7wohb3j3kqu")
const TILE_SIZE = 350

enum TileMode {
	ONE_TILE = 1,
	TWO_TILE,
	FOUR_TILE = 4
}

@onready var tile_count_opt: OptionButton = %tile_count_opt
@onready var palette_bank_opt: OptionButton = %palette_bank_opt
@onready var tile_texture_grid: GridContainer = %tile_texture_grid
@onready var tile_count_inpt: SpinBox = %tile_count_inpt
@onready var col_count_inpt: SpinBox = %col_count_inpt
@onready var show_grid_btn: Button = %show_grid_btn
@onready var zoom_label: Label = %zoom_label

var mode:TileMode = TileMode.ONE_TILE:
	set = set_tile_count

var show_grid:bool = true : set=set_show_grid
var tile_scale = 1.0 : set=set_tile_scale

var _mouse_inside:bool = false
var _mouse_pos:Vector2  ## position relitive to the hovered tile
var _hovered_tile_data:GBTileData
var _drawing:bool = false


func _ready() -> void:
	_draw_tile_textures()
	_setup_menubar()
	
	set_tile_count(mode)
	set_tile_scale(1.0)
	
	Context.selected_palette_bank_changed.connect(_on_context_bank_changed)
	Context.selected_tile_changed.connect(_draw_tile_textures)
	Project.tiles.tiles_updated.connect(_draw_tile_textures)

func set_tile_count(count:TileMode):
	mode = count
	
	if mode == TileMode.ONE_TILE:
		tile_texture_grid.columns = 1
	if mode == TileMode.TWO_TILE or mode == TileMode.FOUR_TILE:
		tile_texture_grid.columns = 2
	
	tile_count_inpt.value = mode
	col_count_inpt.value = tile_texture_grid.columns
	
	_draw_tile_textures()
	
	Settings.set_setting(count, 'tile_mode', 'tile_editor')
	Settings.save()

func set_show_grid(val):
	show_grid = val
	for child in tile_texture_grid.get_children():
		child.show_grid = val
	
	show_grid_btn.button_pressed = val
	
	Settings.set_setting(val, 'show_grid', 'tile_editor')
	Settings.save()

func _draw_tile_textures():
	for child in tile_texture_grid.get_children():
		child.queue_free()
	
	for i in range(mode):
		var inst:TileTexture = TILE_TEXTURE.instantiate()
		
		var tile_data = Project.tiles.get_tile(Context.selected_tile_index + i)
		if !tile_data:
			return
		
		inst.tile = tile_data
		inst.palette_bank = Context.selected_palette_bank
		inst.custom_minimum_size = Vector2(TILE_SIZE * tile_scale, TILE_SIZE * tile_scale)
		inst.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		inst.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		inst.show_grid = show_grid
		
		tile_texture_grid.add_child(inst)

func set_tile_scale(ts):
	tile_scale = ts
	
	if !tile_texture_grid:
		return
	
	for child in tile_texture_grid.get_children():
		child.custom_minimum_size = Vector2(TILE_SIZE * tile_scale, TILE_SIZE * tile_scale)
	
	zoom_label.text = str(int(tile_scale * 100)) + ' %'

func _draw() -> void:
	if false:
		var grid_mouse_pos = tile_texture_grid.get_local_mouse_position()
		grid_mouse_pos += tile_texture_grid.position
		
		
		var r = Rect2(
			grid_mouse_pos,
			grid_mouse_pos + tile_texture_grid.get_child(0).size
		)
		draw_rect(r, Color.GREEN)

func _process(delta: float) -> void:
	if !_mouse_inside:
		return
	
	#queue_redraw()
	
	_get_hovered_tile()
	
	if _drawing:
		_hovered_tile_data.set_color_index(
			_mouse_pos.x,
			_mouse_pos.y,
			Context.selected_palette_idx
		)
	
	if Input.is_action_just_pressed('zoom_in'):
		tile_scale += 0.1
	
	if Input.is_action_just_pressed('zoom_out'):
		tile_scale -= 0.1

func _get_hovered_tile():
	for child:Control in tile_texture_grid.get_children():
		var child_mouse_pos = child.get_local_mouse_position()
		
		if (child_mouse_pos.x > child.size.x or child_mouse_pos.y > child.size.y) or (child_mouse_pos.x < 0 or child_mouse_pos.y < 0):
			continue
		
		_mouse_pos = child_mouse_pos
		_mouse_pos.x = int(_mouse_pos.x / (child.size.x / GBTileData.TILE_SIZE))
		_mouse_pos.y = int(_mouse_pos.y / (child.size.y / GBTileData.TILE_SIZE))
		
		if _hovered_tile_data != child.tile:
			_hovered_tile_data = child.tile

func _setup_menubar():
	# banks dropdown
	for i in range(16):
		palette_bank_opt.add_item('Bank ' + str(i))
	
	palette_bank_opt.select(Context.selected_palette_bank)
	
	tile_count_opt.select(tile_count_opt.get_item_index(mode))

	#col and tile count
	tile_count_inpt.value = mode
	col_count_inpt.value = tile_texture_grid.columns
	
	show_grid_btn.button_pressed = show_grid
	show_grid_btn.toggled.connect(_on_show_grid_btn_toggled)
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_drawing = event.pressed and _mouse_inside

func _on_context_bank_changed(bank:int):
	palette_bank_opt.select(bank)
	_draw_tile_textures()

func _on_tile_texture_grid_mouse_entered() -> void:
	_mouse_inside = true

func _on_tile_texture_grid_mouse_exited() -> void:
	_mouse_inside = false

func _on_tile_count_opt_item_selected(index: int) -> void:
	mode = tile_count_opt.get_item_id(index)

func _on_palette_bank_opt_item_selected(index: int) -> void:
	CommandPalette.call_command('tileeditor:setpalettebank', index)

func _on_tile_count_inpt_value_changed(value: float) -> void:
	mode = int(value)

func _on_col_count_inpt_value_changed(value: float) -> void:
	tile_texture_grid.columns = value

func _on_show_grid_btn_toggled(toggled_on: bool) -> void:
	show_grid = toggled_on

func _on_zoom_in_btn_pressed() -> void:
	tile_scale += 0.1

func _on_zoom_out_btn_pressed() -> void:
		tile_scale -= 0.1
