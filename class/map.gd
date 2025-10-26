class_name Map


signal tile_attrib_updated()
signal resized()

var map_name:String = 'Untitled'
var size:Vector2 = Vector2(32, 32)

var tile_attrbs:Array[GBATileAttrib] = []


func _init(map_size:Vector2 = Vector2(32, 32)) -> void:
	size = map_size
	
	for i in range(size.x * size.y):
		var t = GBATileAttrib.new()
		tile_attrbs.append(t)

func set_tile(x:int, y:int, idx:int):
	tile_attrbs[(y * size.x) + x].tile_index = idx
	tile_attrib_updated.emit()

func get_tile(x:int, y:int) -> GBTileData:
	return Project.tiles.get_tile(tile_attrbs[(y * size.x) + x].tile_index)

func get_tile_atrib(x:int, y:int) -> GBATileAttrib:
	return tile_attrbs[(y * size.x) + x]

func get_tile_attribs() -> Array[GBATileAttrib]:
	return tile_attrbs

func set_tile_h_flip(x:int, y:int, flip:bool):
	tile_attrbs[(y * size.x) + x].h_flip = flip
	
	tile_attrib_updated.emit()

func set_tile_v_flip(x:int, y:int, flip:bool):
	tile_attrbs[(y * size.x) + x].v_flip = flip
	
	tile_attrib_updated.emit()

func get_tile_h_flip(x:int, y:int) -> bool:
	return tile_attrbs[(y * size.x) + x].h_flip

func get_tile_v_flip(x:int, y:int) -> bool:
	return tile_attrbs[(y * size.x) + x].v_flip

func set_tile_palette_bank(x:int, y:int, bank:int):
	pass

func resize(new_size:Vector2):
	pass

func clear():
	tile_attrbs.clear()

func get_16_bit_array() -> Array[int]:
	return []
	
func to_dict() -> Dictionary:
	var d = {
		'name': map_name,
		'size': {
			'x': size.x,
			'y': size.y
		},
		'attrs': []
	}
	
	for attr in tile_attrbs:
		d['attrs'].append(attr.to_dict())
	
	return d

static func from_dict(dict:Dictionary, old_map:Map):
	old_map.clear()
	old_map.map_name = dict.get('name', 'Untitled')
	old_map.size.x = dict.get('size', {}).get('x', 0)
	old_map.size.y = dict.get('size', {}).get('y', 0)
	
	for attr in dict.get('attrs', []):
		old_map.tile_attrbs.append(GBATileAttrib.from_dict(attr))
	
	old_map.tile_attrib_updated.emit()
