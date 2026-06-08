extends GBPaletteData
class_name RGBPaletteData



func add_color(color=Color.WHITE) -> void:
	_colors.append(color)
	palette_updated.emit()

func get_color(id:int) -> Color:
	if _colors.is_empty():
		return Color.BLACK
	
	return _colors.get(id)

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
