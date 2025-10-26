extends Node


signal selected_palette_idx_changed(idx:int)
signal selected_palette_bank_changed(bank:int)
signal selected_tile_changed(idx:int)

var selected_palette_bank:int = 0 :
	set(val):
		if val == selected_palette_bank:
			return
		
		selected_palette_bank = val
		selected_palette_bank_changed.emit(val)

var selected_palette_idx:int = 0 :
	set(val):
		selected_palette_idx = val
		selected_palette_idx_changed.emit(val)

var selected_tile_index:int = 0 :
	set(val):
		selected_tile_index = val
		selected_tile_changed.emit()
