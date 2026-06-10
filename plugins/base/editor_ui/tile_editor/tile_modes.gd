extends PanelContainer
class_name TileModeSelector

const TILE_MODE_BTN_GROUP = preload("uid://ll122ga11ywd")

enum TileMode {
	SINGLE,
	MULTIPLE
}
enum TileCount {
	TWO_TILES  = 2,
	FOUR_TILES = 4,
	NINE_TILES = 9,
}

signal tile_mode_changed(mode:TileMode)
signal tile_count_changed(count:TileCount)
signal repeat_selected_tile_set(is_set:bool)

@onready var tile_count_opt: OptionButton = %tile_count_opt
@onready var repeat_tile_btn: CheckButton = %repeat_tile_btn

var tile_mode:TileMode = TileMode.SINGLE : set=set_tile_mode
var tile_count:TileCount = TileCount.TWO_TILES : set=set_tile_count
var repeat_selected_tile:bool = true : set=set_repeat_selected_tile


func set_repeat_selected_tile(val):
	repeat_selected_tile = val
	
	if repeat_tile_btn:
		repeat_tile_btn.button_pressed = val

func set_tile_mode(mode:TileMode):
	tile_mode = mode
	var pressed_btn = TILE_MODE_BTN_GROUP.get_buttons().get(tile_mode)
	if pressed_btn:
		pressed_btn.button_pressed = true
	
	if !repeat_tile_btn and tile_count_opt:
		return
	
	if tile_mode == TileMode.MULTIPLE:
		repeat_tile_btn.show()
		tile_count_opt.show()
		return
	
	repeat_tile_btn.hide()
	tile_count_opt.hide()

func set_tile_count(count:TileCount):
	tile_count = count
	
	tile_count_opt.selected = tile_count_opt.get_item_index(tile_count)

func _ready() -> void:
	if !TILE_MODE_BTN_GROUP:
		return
	
	set_tile_mode(tile_mode)
	
	repeat_selected_tile = repeat_tile_btn.button_pressed
	
	TILE_MODE_BTN_GROUP.pressed.connect(_on_tile_mode_btn_group_pressed)

func _on_tile_mode_btn_group_pressed(btn:BaseButton):
	var id = btn.get_index()
	tile_mode = id
	
	tile_mode_changed.emit(id)
	tile_count_changed.emit(tile_count)
	
	pass

func _on_tile_count_opt_item_selected(index: int) -> void:
	tile_count = tile_count_opt.get_item_id(index)
	tile_count_changed.emit(tile_count)

func _on_check_button_toggled(toggled_on: bool) -> void:
	repeat_selected_tile = toggled_on
	repeat_selected_tile_set.emit(toggled_on)
