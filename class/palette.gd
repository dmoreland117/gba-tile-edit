class_name GBPalette


const MAX_COLORS = 256
const BANK_SIZE = 16
const MAX_BANKS = MAX_COLORS / BANK_SIZE

signal palette_updated()
signal palette_idx_updated(idx:int)

var palette_name:String = 'Untitled'
var colors:Array[PaletteColor] = []


func add_color(color:Color):
	colors.append(PaletteColor.new(color))
	palette_updated.emit()

func remove_color(idx:int):
	if !_check_idx_in_bounds(idx):
		return
	
	colors.remove_at(idx)
	palette_updated.emit()

func get_color(idx:int) -> Color:
	if !_check_idx_in_bounds(idx):
		return Color(0, 0, 0)
	
	return colors[idx].color

func set_color(idx:int, color:Color):
	if !_check_idx_in_bounds(idx):
		return
	
	colors[idx].color = color
	palette_updated.emit()

func get_colors() -> Array[Color]:
	var ret:Array[Color] = []
	for pcolor in colors:
		ret.append(pcolor.color)
	
	return ret

func clear():
	colors.clear()
	palette_updated.emit()

func get_bgr5_array() -> Array[int]:
	var ret = []
	for color in colors:
		ret.append(color.get_bgr5())
	
	return ret

func _check_idx_in_bounds(idx:int) -> bool:
	if idx >= colors.size() and idx != 0:
		print('Could not get palette color out of bounds. id: ', idx)
		return false
	if colors.is_empty():
		return false
	
	return true

func to_dict() -> Dictionary:
	var ret = {
		'name': palette_name,
	}

	var colors_bgr5 = []
	for i in range(colors.size()):
		colors_bgr5.append(colors[i].get_bgr5())

	ret['colors_bgr5'] = colors_bgr5

	return ret

static func from_bgr5_array(arr:Array[int]) -> GBPalette:
	var p = GBPalette.new()
	for col_bgr5 in arr:
		p.colors.append(PaletteColor.from_rgb5(col_bgr5))
	
	return p

static func from_dict(dict:Dictionary, old_palette:GBPalette = null) -> GBPalette:
	if old_palette:
		old_palette.palette_name = dict['name']
		old_palette.clear()
		for col in dict['colors_bgr5']:
			old_palette.colors.append(PaletteColor.from_rgb5(col))
		
		old_palette.palette_updated.emit()
		
		return
	
	var p = from_bgr5_array(dict['colors_bgr5'])
	if !p:
		return
	
	p.palette_name = dict['name']
	
	return p

static func bank_and_idx_to_main_idx(bank:int, idx:int) -> int:
	if bank == 0:
		return idx
	
	if bank == 1:
		return BANK_SIZE + idx
	
	return (BANK_SIZE * bank) + idx

static func idx_to_bank_and_bank_idx(idx:int):
	return {
		'bank': int(idx / MAX_BANKS),
		'idx':  idx - int((idx / MAX_BANKS) * BANK_SIZE)
	}
