extends Node



signal selected_tile_changed(idx:int)

signal selected_palette_index_changed(idx:int)
signal selected_palette_bank_changed(bank:int)

var selected_tile_index:int = 0 :
	set(val):
		selected_tile_index = val
		selected_tile_changed.emit()

var selected_palette_index:int = 0 :
	set(val):
		selected_palette_index = val
		selected_palette_index_changed.emit(val)
var selected_palette_bank:int = 0 :
	set(val):
		selected_palette_bank = val
		selected_palette_bank_changed.emit(val)

var selected_main_tab:int = 0
var selected_left_tab:int = 0
var selected_right_tab:int = 0
