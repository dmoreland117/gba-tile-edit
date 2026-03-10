@abstract
class_name GBPaletteData


enum {PALETTE_MODE_FIXED, PALETTE_MODE_RGB}

signal palette_updated()
signal palette_color_updated(id:int)
signal palette_name_changed(new_name:String)

var _colors:Array[Color] = []


@abstract func add_color()
@abstract func get_color(id:int)
@abstract func set_color(id:int, color:Color)
@abstract func remove_color(id:int)

func get_colors() -> Array[Color]:
	return _colors











#
#signal palette_updated()
#signal palette_mode_changed(mode:int)
#signal fixed_colors_registered()
#signal palette_name_changed(new_name:String)
#
#var palette_name:String = 'Untitled' : set=set_palette_name
#var colors:Array[GBPaletteColor] = []
#var fixed_color_palette:Array[Color] = []
#
#var mode:int = PALETTE_MODE_RGB : set=set_palette_mode
#
#var bank_size:int = 16
#
#func add_color():
	#if mode == PALETTE_MODE_RGB:
		#colors.append(GBPaletteColor.new(Color.WHITE))
		#palette_updated.emit()
		#return
	#
	#if mode == PALETTE_MODE_FIXED:
		#if fixed_color_palette.is_empty():
			#return
		#
		#colors.append(GBPaletteColor.from_fixed_pal_idx(0, fixed_color_palette))
		#palette_updated.emit()
#
#func remove_color(idx:int):
	#if !_check_idx_in_bounds(idx):
		#return
	#
	#colors.remove_at(idx)
	#palette_updated.emit()
#
#func register_fixed_palette(palette:Array[Color]):
	#if mode == PALETTE_MODE_FIXED:
		#fixed_color_palette = palette
	#
	#fixed_colors_registered.emit()
#
#func get_color(idx:int) -> Color:
	#if !_check_idx_in_bounds(idx):
		#return Color(0, 0, 0)
	#
	#return colors[idx].color
#
#func set_color(idx:int, color):
	#if !_check_idx_in_bounds(idx):
		#return
	#
	#if mode == PALETTE_MODE_RGB:
		#colors[idx].color = color
		#palette_updated.emit()
	#
	#if mode == PALETTE_MODE_FIXED:
		#if typeof(color) != TYPE_INT:
			#return
		#
		#colors[idx].fixed_palette_idx = color
		#palette_updated.emit()
#
#func get_colors() -> Array[Color]:
	#var ret:Array[Color] = []
	#for pcolor in colors:
		#ret.append(pcolor.color)
	#
	#return ret
#
#func clear():
	#colors.clear()
	#palette_updated.emit()
#
#func get_bgr5_array() -> Array[int]:
	#var ret:Array[int] = []
	#for color in colors:
		#ret.append(color.get_bgr5())
	#
	#return ret
#
#func _check_idx_in_bounds(idx:int) -> bool:
	#if idx < 0 or idx >= colors.size():
		#print('Could not get palette color out of bounds. id: ', idx)
		#return false
	#if colors.is_empty():
		#return false
	#
	#return true
#
#func to_dict() -> Dictionary:
	#var ret = {
		#'name': palette_name,
	#}
#
	#var colors_rgb8 = []
	#for i in range(colors.size()):
		#colors_rgb8.append(colors[i].get_rgb8())
	#
	#ret['colors_rgb8'] = colors_rgb8
	#
	#return ret
#
#func set_palette_mode(m:int):
	#mode = m
	#if m == PALETTE_MODE_FIXED:
		#clear()
		#add_color()
	#
	#palette_mode_changed.emit(mode)
#
#func set_selected_palette_bank(bank:int):
	#if bank == Context.selected_palette_bank_index:
		#return
		#
	#Context.selected_palette_bank_index = bank
#
#func set_selected_palette_idx(idx:int):
	#Context.selected_palette_idx = idx
#
#func set_palette_name(new_name:String):
	#palette_name = new_name
	#palette_name_changed.emit(new_name)
#
#static func from_bgr5_array(arr:Array[int]) -> GBPaletteData:
	#var p = GBPaletteData.new()
	#for col_bgr5 in arr:
		#p.colors.append(GBPaletteColor.from_rgb5(col_bgr5))
	#
	#return p
#
#static func from_dict(dict:Dictionary, old_palette:GBPaletteData = null) -> GBPaletteData:
	#if old_palette:
		#old_palette.palette_name = dict['name']
		#old_palette.clear()
		#for col in dict['colors_bgr5']:
			#old_palette.colors.append(GBPaletteColor.from_rgb8(col))
		#
		#old_palette.palette_updated.emit()
		#
		#return
	#
	#var p = from_bgr5_array(dict['colors_bgr5'])
	#if !p:
		#return
	#
	#p.palette_name = dict['name']
	#
	#return p
#
#func bank_and_idx_to_main_idx(bank:int, idx:int) -> int:
	#if bank == 0:
		#return idx
	#
	#if bank == 1:
		#return bank_size + idx
	#
	#return (bank_size * bank) + idx
