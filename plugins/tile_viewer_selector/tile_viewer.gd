extends ScrollContainer
class_name TileViewer

const TILE_TEXTURE = preload('res://widget/tile_texture.tscn')

signal selection_updated()

@onready var tiles_grid:GridContainer = %tiles_grid
@onready var selection_overlay:Control = %selection_overlay

var tiles:Array[GBTileData] = [] : set=set_tiles
var grid_cols:int = 4 : set=set_grid_columns

var _mouse_inside:bool = false
var _mouse_pos:Vector2

var _dragging:bool = false
var _Start_drag_pos:Vector2
var _current_drag_pos:Vector2
var _start_tile_pos:Vector2i
var _current_tile_pos:Vector2i


func set_tiles(new_tiles):
	tiles = new_tiles
	
	_populate_tiles()

func set_grid_columns(cols):
	grid_cols = cols
	if tiles_grid:
		tiles_grid.columns = cols

func get_cell_at_position(pos:Vector2) -> Vector2i:
	var first_grid_child = null
	if !tiles_grid.get_child_count() > 0:
		return Vector2i.ZERO
	
	first_grid_child = tiles_grid.get_child(0)
	
	var cell_size_x = first_grid_child.size.x
	var cell_size_y = first_grid_child.size.y
	
	return Vector2i(
		pos.x / cell_size_x,
		pos.y / cell_size_y
	)

func _clear_children():
	for child in tiles_grid.get_children():
		
		tiles_grid.remove_child(child)
		child.queue_free()

func _populate_tiles():
	_clear_children()
	
	for tile in tiles:
		var inst = TILE_TEXTURE.instantiate()
		var a:Array[GBTileData] = [tile]
		inst.tiles = a
		inst.palette = Project.get_selected_palette()
		inst.custom_minimum_size.x = 64
		inst.custom_minimum_size.y = 64
		
		tiles_grid.add_child(inst)

func _ready() -> void:
	set_tiles(tiles)

func get_selection() -> Dictionary:
	if !tiles_grid:
		return {
			"position": Vector2i(0, 0),
			'start_tile_idx': 0,
			"size": Vector2i(1, 1)
		}
	
	var min_cell = Vector2i(
		min(_start_tile_pos.x, _current_tile_pos.x),
		min(_start_tile_pos.y, _current_tile_pos.y)
	)

	var max_cell = Vector2i(
		max(_start_tile_pos.x, _current_tile_pos.x),
		max(_start_tile_pos.y, _current_tile_pos.y)
	)
	
	return {
		"position": min_cell,
		'start_tile_idx': min_cell.x + (min_cell.y * tiles_grid.columns),
		"size": (max_cell - min_cell) + Vector2i(1, 1)
	}

func get_selected_cells() -> Array[Vector2i]:
	var result:Array[Vector2i] = []

	var sel = get_selection()
	var pos = sel.position
	var size = sel.size

	for y in range(size.y):
		for x in range(size.x):
			result.append(Vector2i(pos.x + x, pos.y + y))

	return result

func get_selected_ids() -> Array[int]:
	var result:Array[int] = []

	var sel = get_selection()
	var pos = sel.position
	var size = sel.size

	for y in range(size.y):
		for x in range(size.x):
			result.append(get_tile_id(Vector2i(pos.x + x, pos.y + y)))

	return result

func get_tile_id(pos:Vector2i) -> int:
	return pos.x + (pos.y * grid_cols)

func _process(delta: float) -> void:
	if !_mouse_inside:
		return
	
	_mouse_pos = get_local_mouse_position()
	
	if !_dragging:
		return
	
	_current_drag_pos = _mouse_pos
	_current_tile_pos = get_cell_at_position(_mouse_pos)
	
	selection_updated.emit()
	
	queue_redraw()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if !event.button_index == MOUSE_BUTTON_LEFT:
			return
		
		if !_dragging and event.pressed:
			_dragging = true
			selection_overlay._dragging = true
			
			_Start_drag_pos = _mouse_pos
			_start_tile_pos = get_cell_at_position(_mouse_pos)
		if _dragging and not event.pressed:
			_dragging = false
			selection_overlay._dragging = false
			
			queue_redraw()

func _on_mouse_entered() -> void:
	_mouse_inside = true

func _on_mouse_exited() -> void:
	_mouse_inside = false
