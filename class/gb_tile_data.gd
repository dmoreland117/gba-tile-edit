class_name GBTileData


const FOUR_BPP_TILE_DATA_SIZE := 32   # 8×8×4 bits
const EIGHT_BPP_TILE_DATA_SIZE := 64  # 8×8×8 bits

signal tile_updated()

var data: Array = []
var size:Vector2 = Vector2.ZERO

func _init(tile_size:Vector2) -> void:
	size = tile_size
	data.resize(size.x * size.y)
	data.fill(0)

func set_color_index(x: int, y: int, idx: int) -> void:
	if x < 0 or x >= size.x or y < 0 or y >= size.y:
		printerr("Out of bounds pixel (", x, ",", y, ")")
		return

	data[(y * size.x) + x] = idx
	
	tile_updated.emit()


func get_color_index(x: int, y: int) -> int:
	if x < 0 or x >= size.x or y < 0 or y >= size.y:
		printerr("Out of bounds pixel (", x, ",", y, ")")
		return 0

	return data[(y * size.x) + x] 

func get_8bpp_array() -> PackedByteArray:
	return PackedByteArray(data)

func get_4bpp_array() -> PackedByteArray:
	var ret = PackedByteArray()
	
	for i in range(0, data.size(), 2):
		var col_idx = data[i] & 0xF
		var col_idx_2 = data[i + 1] & 0xF
		
		var byte = (col_idx_2 << 4) | col_idx
		ret.append(byte)
	
	return ret
