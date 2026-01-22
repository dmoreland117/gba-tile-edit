extends GBEditPlugin


const TILES_CONTAINER = preload("uid://btej4pvrnpkp2")


func _enter_tree() -> void:
	var tc = TILES_CONTAINER.instantiate()
	Ui.get_container(Ui.RIGHT_CONTAINER).add_child(tc)
	
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

func _add_tileset(tileset_name:String = '', size:Vector2i = Vector2i(8, 8)):
	if tileset_name.is_empty():
		Popups.show_create_tileset_window()
		return true
		
	var ts = GBTileSet.new(size)
	ts.tileset_name = tileset_name
	
	Project.add_tileset(ts)
	
	return true
