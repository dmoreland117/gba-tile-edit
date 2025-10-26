class_name GBTileData


const TILE_SIZE := 8
const FOUR_BPP_TILE_DATA_SIZE := 32   # 8×8×4 bits
const EIGHT_BPP_TILE_DATA_SIZE := 64  # 8×8×8 bits

signal tile_updated()

var data: Array[int] = []


func _init() -> void:
	data.resize(TILE_SIZE * TILE_SIZE)
	data.fill(0)

func set_color_index(x: int, y: int, idx: int) -> void:
	if x < 0 or x >= TILE_SIZE or y < 0 or y >= TILE_SIZE:
		printerr("Out of bounds pixel (", x, ",", y, ")")
		return

	data[(y * TILE_SIZE) + x] = idx
	
	tile_updated.emit()


func get_color_index(x: int, y: int) -> int:
	if x < 0 or x >= TILE_SIZE or y < 0 or y >= TILE_SIZE:
		printerr("Out of bounds pixel (", x, ",", y, ")")
		return 0

	return data[(y * TILE_SIZE) + x] 

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
