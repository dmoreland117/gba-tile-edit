extends Node



signal selected_tile_changed(idx:int)


var selected_tile_index:int = 0 :
	set(val):
		selected_tile_index = val
		selected_tile_changed.emit()
