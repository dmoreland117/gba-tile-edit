extends Control


@export var tile_viewer:TileViewer

var cell_size:Vector2i : set=set_cell_size
var selection:Dictionary : set=set_selection
var _dragging:bool = false : set=set_dragging


func set_dragging(drag):
	_dragging = drag
	queue_redraw()

func set_selection(sel):
	selection = sel
	queue_redraw()

func set_cell_size(new_size):
	cell_size = new_size
	queue_redraw()

func _ready() -> void:
	cell_size = Vector2i(64, 64)
	selection = tile_viewer.get_selection()
	tile_viewer.selection_updated.connect(_on_grid_selection_updated)

func set_cell_size_to_first_child_size():
	if tile_viewer:
		if !tile_viewer.tiles_grid:
			return
		if tile_viewer.tiles_grid.get_child_count() == 0:
			return
		
		cell_size = tile_viewer.tiles_grid.get_child(0).size

func _draw() -> void:
	if selection.is_empty():
		return
	
	var rect_pos = Vector2i(selection.position) * cell_size
	var rect_size = Vector2i(selection.size) * (cell_size + Vector2i(1, 1))

	if _dragging:
		draw_rect(Rect2(rect_pos, rect_size), Color(0, 0.5, 1, 0.3), true)
	
	draw_rect(Rect2(rect_pos, rect_size), Color(0, 0.5, 1), false, 2)

func _on_grid_selection_updated():
	selection = tile_viewer.get_selection()
