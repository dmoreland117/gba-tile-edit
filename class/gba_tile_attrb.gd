class_name GBATileAttrib


var tile_index:int = 0

var palette_bank_index:int = 0:
	set(val):
		palette_bank_index = clamp(val, 0, 15)

var h_flip:bool = false
var v_flip:bool = false


func get_16_bit() -> int:
	var ret = tile_index
	
	if h_flip:
		ret |= 1 << 10
	if v_flip:
		ret |= 1 << 11
	
	return ret

func to_dict() -> Dictionary:
	return {
		'idx': tile_index,
		'palette_idx': palette_bank_index,
		'h_flip': h_flip,
		'v_flip': v_flip
	}

static func from_dict(dict:Dictionary) -> GBATileAttrib:
	var attr = GBATileAttrib.new()
	attr.tile_index = dict.get('idx', 0) 
	attr.palette_bank_index = dict.get('palette_idx', 0)
	attr.h_flip = dict.get('h_flip', false)
	attr.v_flip = dict.get('v_flip', false)
	
	return attr
