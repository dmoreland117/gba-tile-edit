extends Node


signal selected_tileset_index_changed(idx:int)
signal selected_tile_changed(idx:int)

signal selected_palette_index_changed(idx:int)
signal selected_palette_color_index_changed(idx:int)
signal selected_palette_bank_changed(bank:int)

signal Selected_map_index_changed(idx:int)

var selected_tileset_index:int = 0 :
	set(val):
		Log.pr('set tileset index:', val)
		selected_tileset_index = val
		selected_tileset_index_changed.emit(val)
var selected_tileset_tile_index:int = 0 :
	set(val):
		Log.pr('set tile index:', val)
		
		selected_tileset_tile_index = val
		selected_tile_changed.emit(val)

var selected_palette_index:int = 0 :
	set(val):
		Log.pr('set palette index:', val)
		
		selected_palette_index = val
		selected_palette_index_changed
var selected_palette_color_index:int = 0 :
	set(val):
		Log.pr('set palette color index:', val)
		
		selected_palette_color_index = val
		selected_palette_color_index_changed.emit(val)
var selected_palette_bank_index:int = 0 :
	set(val):
		Log.pr('set palette bank index:', val)
		
		selected_palette_bank_index = val
		selected_palette_bank_changed.emit(val)

var selected_map_index:int = 0 : 
	set(val):
		Log.pr('set map index:', val)
		
		selected_map_index = val
		Selected_map_index_changed.emit(val)

var selected_main_tab:int = 0
var selected_left_tab:int = 0
var selected_right_tab:int = 0
