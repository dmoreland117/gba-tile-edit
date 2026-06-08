class_name TileContainer
extends VBoxContainer

signal selection_updated()

@onready var tile_viewer:TileViewer = %tile_viewer
@onready var selection_info_label:TemplateLabel = %selection_info_label

var tileset:GBTileSet : set=set_tileset
var selection:Dictionary = {} : set=_set_selection


func _set_selection(new_sel):
	selection = new_sel
	selection_updated.emit()

func set_tileset(new_tileset):
	tileset = new_tileset
	if tile_viewer and tileset:
		tile_viewer.tiles = tileset.get_tiles()
		_set_up_selected_tileset_signals()

func _update_selection(sel:Dictionary, cells:Array[Vector2i], ids:Array[int]):
	var new_sel = {
		
	}
	
	new_sel['rect'] = sel
	new_sel['cells'] = cells
	new_sel['ids'] = ids
	
	selection = new_sel
	
	if selection_info_label:
		selection_info_label.replace['start_tile'] = str(sel.position)
		selection_info_label.replace['selection_size'] = str(sel.size)
		selection_info_label.replace_text()

func _set_up_selected_tileset_signals():
	tileset.tiles_updated.connect(
		func():
			tile_viewer.tiles = tileset.get_tiles()
	)

func _ready() -> void:
	set_tileset(tileset)
	
	_on_tile_viewer_selection_updated()

func _on_tile_viewer_selection_updated() -> void:
	var s = tile_viewer.get_selection()
	var c = tile_viewer.get_selected_cells()
	var ids = tile_viewer.get_selected_ids()
	
	_update_selection(s, c, ids)
	pass

func _on_add_color_btn_pressed() -> void:
	Project.get_selected_tileset().add_tile(GBTileData.new())
