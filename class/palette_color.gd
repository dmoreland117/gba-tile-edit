class_name PaletteColor


var color:Color
var fixed_palette_idx:int = 0 :
	set(val):
		fixed_palette_idx = val
		color = palette[val]
		
var palette:Array[Color] = []


func _init(col:Color) -> void:
	color = col

func get_bgr5() -> int:
	var r5 = clamp(int(color.r8 >> 3), 0, 31)
	var g5 = clamp(int(color.g8 >> 3), 0, 31)
	var b5 = clamp(int(color.b8 >> 3), 0, 31)
	var ret = 0
	ret = (b5 << 10) | (g5 << 5) | r5
	return ret

static func from_rgb5(rgb5:int) -> PaletteColor:
	var b5 = (rgb5 >> 10) & 0x1F 
	var g5 = (rgb5 >> 5) & 0x1F 
	var r5 = rgb5 & 0x1F 
	
	var b8 = (b5 << 3) | (b5 >> 2)
	var g8 = (g5 << 3) | (g5 >> 2)
	var r8 = (r5 << 3) | (r5 >> 2)
	
	var c = Color(1, 1, 1)
	c.r8 = r8
	c.b8 = b8
	c.g8 = g8
	
	return PaletteColor.new(c)

static func from_fixed_pal_idx(idx:int, pal:Array[Color]):
	if pal.is_empty():
		return PaletteColor.new(Color.WHITE)
	
	var pc = PaletteColor.new(pal[idx])
	pc.palette = pal
	pc.fixed_palette_idx = idx
	return pc
	
