class_name GBTileSet


signal tiles_updated()

var tileset_name = 'Untitled'
var tile_datas:Array[GBTileData] = []


func add_tile(tile:GBTileData = null):
	if !tile:
		tile_datas.append(GBTileData.new())
		tiles_updated.emit()
		return
	
	tile_datas.append(tile)
	tiles_updated.emit()

func remove_tile(idx:int):
	if !_check_idx_in_bounds(idx):
		return
	
	tile_datas.remove_at(idx)
	
	tiles_updated.emit()

func get_tile(idx:int) -> GBTileData:
	if !_check_idx_in_bounds(idx):
		return null
	
	return tile_datas[idx]

func set_tile(idx:int, tile:GBTileData):
	if !_check_idx_in_bounds(idx):
		return
	
	tile_datas[idx] = tile
	
	tiles_updated.emit()

func get_tile_count() -> int:
	return tile_datas.size()

func get_tiles():
	return tile_datas

func clear():
	tile_datas.clear()
	tiles_updated.emit()

func get_16_bit_array() -> Array[int]:
	var ret:Array[int] = []
	for tile in tile_datas:
		ret.append(tile.get_bytes_array())
	
	return []

func get_8_bit_array() -> Array[int]:
	return get_16_bit_array()

func _check_idx_in_bounds(idx:int) -> bool:
	return idx >= 0 and idx < tile_datas.size()

func to_dict():
	var dict = {
		'name': tileset_name,
	}
	
	var tiles_arr = []
	for tile in tile_datas:
		tiles_arr.append(tile.data)
	
	dict['tiles'] = tiles_arr
	
	return dict

static func from_dict(dict:Dictionary, old_tiles:GBTileSet):
	old_tiles.tileset_name = dict['name']
	old_tiles.clear()
	for data:Array in dict['tiles']:
		var t = GBTileData.new()
		t.data.clear()
		for i in data:
			t.data.append(int(i))
		
		old_tiles.tile_datas.append(t)
	
	old_tiles.tiles_updated.emit()
	
