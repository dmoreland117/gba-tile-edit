class_name TileContainer
extends VBoxContainer

const TILE_CONTAINER_ITEM = preload("uid://daahiu68kj761")

@onready var tile_grid: GridContainer = %tile_grid
@onready var selected_tileset_opt: OptionButton = %selected_tileset_opt

func _ready() -> void:
	_draw_tile_items()
	Project.get_tileset(Context.selected_tileset_index).tiles_updated.connect(_draw_tile_items)
	_populate_selected_tileset_opt()
	
	Context.selected_tileset_index_changed.connect(_on_context_tileset_index_updated)
	Project.tilesets_updated.connect(_populate_selected_tileset_opt)

func _on_context_tileset_index_updated(idx:int):
	_draw_tile_items()
	Project.get_tileset(idx).tiles_updated.connect(_draw_tile_items)

func _populate_selected_tileset_opt():
	selected_tileset_opt.clear()
	
	for tileset in Project.get_tilesets():
		selected_tileset_opt.add_item(tileset.tileset_name)

func _draw_tile_items(_id=0):
	for child in tile_grid.get_children():
		tile_grid.remove_child(child)
		child.queue_free()
	
	for tile in Project.get_tileset(Context.selected_tileset_index).get_tiles():
		var inst:Button = TILE_CONTAINER_ITEM.instantiate()
		inst.tile = tile
		tile_grid.add_child(inst)
		inst.pressed.connect(
			func():
				Context.selected_tile_index = inst.get_index()
		)

func _on_add_color_btn_3_pressed() -> void:
	Project.get_tileset(Context.selected_tileset_index).add_tile()

func _on_remove_tile_btn_4_pressed() -> void:
	Project.get_tileset(Context.selected_tileset_index).remove_tile(Context.selected_tile_index)


func _on_selected_tileset_opt_item_selected(index: int) -> void:
	Context.selected_tileset_index = index
