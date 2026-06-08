extends GBPaletteData
class_name FixedPaletteData


var _indexed_colors:Array[int] = []
var _fixed_colors:Array[Color] = []

func register_fixed_colors(colors:Array) -> void:
	_fixed_colors.clear()
	
	for color in colors:
		_fixed_colors.append(color)

func set_color_indexed(id:int, col_idx:int) -> void:
	_indexed_colors[id] = col_idx
	palette_color_updated.emit(id, _fixed_colors[col_idx])

func add_color() -> void:
	_indexed_colors.append(0)
	palette_updated.emit()

func get_color(id:int) -> Color:
	if _indexed_colors.is_empty():
		return Color.BLACK
	
	if id >= _indexed_colors.size():
		return Color.BLACK
	
	return _fixed_colors.get(_indexed_colors[id])

func set_color(id:int, color:Color) -> void:
	if id >= _colors.size():
		return
	
	_colors.set(id, color)
	palette_color_updated.emit(id, color)

func remove_color(id:int) -> void:
	if id >= _colors.size():
		return
	
	_colors.remove_at(id)
	palette_updated.emit()

func get_colors() -> Array[Color]:
	var ret:Array[Color] = []
	
	for idx in _indexed_colors:
		ret.append(_fixed_colors.get(idx))
	
	return ret
	
func get_fixed_colors() -> Array[Color]:
	return _fixed_colors

func get_indexed_colors() -> Array[int]:
	return _indexed_colors
