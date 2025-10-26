extends Node


enum {
	TILE_MODE_4BPP,
	TILE_MODE_8BPP
}

var proj_name = 'Untitled'
var tile_mode:int = TILE_MODE_8BPP
var needs_save:bool = false
var last_save_path:String = ''

var palette:GBPalette = GBPalette.new()
var tiles:GBTileSet = GBTileSet.new()
var map:Map = Map.new()

func create_initail_project():
	palette.add_color(Color.WHITE)
	tiles.add_tile()

func save(path:String):
	var dict = {
		'name': proj_name,
		'save_path': path,
		'palette': palette.to_dict(),
		'tileset': tiles.to_dict(),
		'map': map.to_dict()
	}
	
	last_save_path = path
	
	var file = FileAccess.open(path, FileAccess.WRITE)
	if !file:
		return
	
	file.store_string(str(dict))
	
	file.close()

func load(path:String):
	var dict_String = FileAccess.get_file_as_string(path)
	if dict_String.is_empty():
		return
	
	var dict = JSON.parse_string(dict_String)
	proj_name = dict.get('name', 'Untitled')
	last_save_path = path
	GBPalette.from_dict(dict['palette'], palette)
	GBTileSet.from_dict(dict['tileset'], tiles)
	Map.from_dict(dict['map'], map)
