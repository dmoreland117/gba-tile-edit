extends GBEditPlugin


const TILES_CONTAINER = preload("uid://btej4pvrnpkp2")
var tile_container:TileContainer


func _enter_tree() -> void:
	tile_container = TILES_CONTAINER.instantiate()
	Ui.get_container(Ui.RIGHT_CONTAINER).add_child(tile_container)
	tile_container.tileset = Project.get_selected_tileset()
	tile_container.selection_updated.connect(_on_selection_updated)
	
	
	register_command(
			'addtileset',
			[
				{
					'name': 'name',
					'type': TYPE_STRING
				},
				{
					'name': 'size',
					'type': TYPE_VECTOR2I
				}
			],
			_add_tileset
		)

func _on_selection_updated():
	var te := Ui.get_tile_editor()
	if !te:
		return
	
	var sel = tile_container.selection
	
	Context.selected_tileset_tile_index = sel.rect.start_tile_idx
	te.tile_cols = sel.rect.size.x
	var tiles:Array[GBTileData] = []
	for tile in sel.ids:
		var t = Project.get_selected_tileset().get_tile(tile)
		if t:
			tiles.append(t)
		else:
			tiles.append(Project.get_selected_tileset().get_tile(0))
	
	te.tile_texture.tiles = tiles
	
func _add_tileset(tileset_name:String = '', size:Vector2i = Vector2i(8, 8)):
	if tileset_name.is_empty():
		Popups.show_create_tileset_window()
		return true
		
	var ts = GBTileSet.new(size)
	ts.tileset_name = tileset_name
	
	Project.add_tileset(ts)
	
	return true
