extends VBoxContainer
class_name TileEditor

const GRID_OPTIONS_MENU = preload('res://plugins/tile_editor/grid_options.tscn')
const BASE_SCALE = 12.0

@onready var tile_texture: TileTexture = $bg_panel/ScrollContainer/tile_texture
@onready var zoom_control: PanelContainer = %zoom_control
@onready var tile_modes: TileModeSelector = %tile_modes
@onready var grid_dripdown: HBoxContainer = %grid_dropdown
@onready var grid_viewer: Control = %grid_viewer

var tile_bank:int = 0
var tile_idx:int = 0 : set=set_tile_idx
var tile_count:int = 1 : set=set_tile_count
var tile_cols:int = 1 : set=set_tile_cols

var show_grid:bool = false
var zoom_step:float = 0.1
var zoom:float = 4.0 : set=set_zoom

var _tile_size:Vector2

var _mouse_inside:bool = false
var _mouse_inside_canvas:bool = false
var _mouse_pos:Vector2 : set=_set_mouse_pos
var _mouse_pixel_pos:Vector2i

var _drawing:bool = false


func set_palette(id:int):
	if !tile_texture:
		return
	
	tile_texture.palette = Project.get_palette(id)

func set_tile_count(count:int):
	tile_count = count
	
	if !tile_texture:
		return
	
	var tiles:Array[GBTileData] = []
	if tile_modes.repeat_selected_tile:
		
		for i in range(count):
			tiles.append(Project.get_selected_tileset().get_tile(tile_idx))
		
		tile_texture.tiles = tiles
		return
	
	tiles = Project.get_selected_tileset().get_tile_range(tile_idx, tile_count)
	
	tile_texture.tiles = tiles
	

func set_tile_cols(cols:int):
	tile_cols = cols
	
	if tile_texture:
		tile_texture.tile_columns = cols

func set_zoom(new_zoom:float):
	zoom = clamp(new_zoom, 1.0, 100)
	if zoom_control:
		zoom_control.value = new_zoom
	
	# resize the tile
	_on_tile_texture_tiles_set()

func set_tile_idx(idx:int):
	tile_idx = idx
	
	var tiles = Project.get_selected_tileset().get_tile_range(tile_idx, tile_count)
	if tile_texture:
		tile_texture.tile_columns = tile_cols
		tile_texture.tiles = tiles

func set_pixel(x:int, y:int, index:int):
	var data = tile_texture.get_tile_and_pixel_coords_from_global_pixel_pos(x, y)
	
	if data.data:
		data.data.set_color_index(data.x, data.y, index)

func set_pixelv(pos:Vector2i, index):
	set_pixel(pos.x, pos.y, index)

func _set_mouse_pos(pos):
	_mouse_pos = pos
	
	var px_size_x = tile_texture.size.x / tile_texture.get_width()
	var px_size_y = tile_texture.size.y / tile_texture.get_height()
	
	_mouse_pixel_pos = Vector2i(
		pos.x / px_size_x,
		pos.y / px_size_y
	)
	pass

func _on_tile_texture_tiles_set():
	if !tile_texture:
		return
	
	tile_texture.custom_minimum_size.x = (tile_texture.get_width() * BASE_SCALE) * zoom
	tile_texture.custom_minimum_size.y = (tile_texture.get_height() * BASE_SCALE) * zoom

func _on_tile_texture_mouse_entered() -> void:
	_mouse_inside_canvas = true

func _on_tile_texture_mouse_exited() -> void:
	_mouse_inside_canvas = false

func _on_bg_panel_mouse_entered() -> void:
	_mouse_inside = true

func _on_bg_panel_mouse_exited() -> void:
	_mouse_inside = false

func _process(delta: float) -> void:
	if _mouse_inside:
		if Input.is_action_just_pressed('zoom_in'):
			zoom += zoom_step
		if Input.is_action_just_pressed('zoom_out'):
			zoom -= zoom_step
	
	if !_mouse_inside_canvas:
		return
	
	_mouse_pos = tile_texture.get_local_mouse_position()
	
	_drawing = false
	if Input.is_action_pressed("draw"):
		_drawing = true
	
	if _drawing:
		set_pixelv(
			_mouse_pixel_pos,
			Context.selected_palette_color_index
		)

func _ready() -> void:
	var grid_opt_popup = GRID_OPTIONS_MENU.instantiate()
	grid_opt_popup.grid_data = grid_viewer.data
	grid_dripdown.get_popup().add_child(grid_opt_popup)
	
	grid_viewer.data.show_grid = true
	
	tile_texture.palette = Project.get_selected_palette()
	tile_texture.tiles_set.connect(_on_tile_texture_tiles_set)
	set_tile_idx(tile_idx)
	
	Ui.register_tile_editor(self)

func _on_zoom_slider_value_changed(new_value: Variant) -> void:
	zoom = new_value

func _on_tile_modes_tile_mode_changed(mode: int) -> void:
	if mode == TileModeSelector.TileMode.SINGLE:
		tile_count = 1
		tile_cols = 1
		
		return
	
	tile_count = tile_modes.tile_count

func _on_tile_modes_tile_count_changed(count: TileModeSelector.TileCount) -> void:
	if tile_modes.tile_mode == TileModeSelector.TileMode.SINGLE:
		tile_cols = 1
		tile_count = 1
		return
	
	match count:
		TileModeSelector.TileCount.TWO_TILES:
			tile_cols = 2
		TileModeSelector.TileCount.FOUR_TILES:
			tile_cols = 2
		TileModeSelector.TileCount.NINE_TILES:
			tile_cols = 3
	
	tile_count = count


func _on_tile_modes_repeat_selected_tile_set(is_set: bool) -> void:
	set_tile_count(tile_count)


func _on_grid_dropdown_toggled(toggled_on: bool) -> void:
	grid_viewer.data.show_grid = toggled_on
	grid_viewer.data.data_updated.emit()
