class_name GBPalette



enum {PALETTE_MODE_FIXED, PALETTE_MODE_RGB}

signal palette_updated()
signal palette_idx_updated(idx:int)
signal palette_mode_changed(mode:int)
signal selected_palette_idx_changed(idx:int)
signal selected_palette_bank_changed(bank:int)
signal fixed_colors_registered()

var palette_name:String = 'Untitled'
var colors:Array[PaletteColor] = []
var fixed_color_palette:Array[Color] = []

var mode:int = PALETTE_MODE_RGB : set=set_palette_mode
var selected_palette_bank:int = 0 : set=set_selected_palette_bank
var selected_palette_idx:int = 0 : set=set_selected_palette_idx

static var bank_size:int = 16

func add_color():
	if mode == PALETTE_MODE_RGB:
		colors.append(PaletteColor.new(Color.WHITE))
		palette_updated.emit()
		return
	
	if mode == PALETTE_MODE_FIXED:
		if fixed_color_palette.is_empty():
			return
		
		colors.append(PaletteColor.from_fixed_pal_idx(0, fixed_color_palette))
		palette_updated.emit()

func remove_color(idx:int):
	if !_check_idx_in_bounds(idx):
		return
	
	colors.remove_at(idx)
	palette_updated.emit()

func register_fixed_palette(palette:Array[Color]):
	if mode == PALETTE_MODE_FIXED:
		fixed_color_palette = palette
	
	fixed_colors_registered.emit()

func get_color(idx:int) -> Color:
	if !_check_idx_in_bounds(idx):
		return Color(0, 0, 0)
	
	return colors[idx].color

func set_color(idx:int, color):
	if !_check_idx_in_bounds(idx):
		return
	
	if mode == PALETTE_MODE_RGB:
		colors[idx].color = color
		palette_updated.emit()
	
	if mode == PALETTE_MODE_FIXED:
		if typeof(color) != TYPE_INT:
			return
		
		colors[idx].fixed_palette_idx = color
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

func set_palette_mode(m:int):
	mode = m
	if m == PALETTE_MODE_FIXED:
		clear()
		add_color()
	
	palette_mode_changed.emit(mode)

func set_selected_palette_bank(bank:int):
	if bank == selected_palette_bank:
		return
		
	selected_palette_bank = bank
	selected_palette_bank_changed.emit(bank)

func set_selected_palette_idx(idx:int):
	selected_palette_idx = idx
	selected_palette_idx_changed.emit(idx)

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
		return bank_size + idx
	
	return (bank_size * bank) + idx
