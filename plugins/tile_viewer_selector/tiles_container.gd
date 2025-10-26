class_name TileContainer
extends VBoxContainer

const TILE_CONTAINER_ITEM = preload("uid://daahiu68kj761")

@onready var tile_grid: GridContainer = %tile_grid

func _ready() -> void:
	_draw_tile_items()
	Project.tiles.tiles_updated.connect(_draw_tile_items)

func _draw_tile_items():
	for child in tile_grid.get_children():
		tile_grid.remove_child(child)
		child.queue_free()
	
	for tile in Project.tiles.get_tiles():
		var inst:Button = TILE_CONTAINER_ITEM.instantiate()
		inst.tile = tile
		tile_grid.add_child(inst)
		inst.pressed.connect(
			func():
				Context.selected_tile_index = inst.get_index()
		)


func _on_import_palette_btn_pressed() -> void:
	pass

func _on_add_color_btn_3_pressed() -> void:
	Project.tiles.add_tile()
