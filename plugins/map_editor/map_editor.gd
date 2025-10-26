extends VBoxContainer


const TILE_TEXTURE = preload("uid://r7wohb3j3kqu")
const MAP_TILE_SIZE = 64

enum {
	MODE_DRAW,
	MODE_HFLIP,
	MODE_VFLIP
}

@onready var grid_container: GridContainer = %GridContainer
@onready var tile_scale_input: SpinBox = %tile_scale_input
@onready var tile_spacing_input: SpinBox = %tile_spacing_input
@onready var mouse_pos_label: Label = %mouse_pos_label
@onready var scroll_container: ScrollContainer = $PanelContainer/ScrollContainer
@onready var mode_btns: HBoxContainer = %mode_btns

var tile_scale:float = 1.0 : set=set_tile_scale
var tile_spacing:int = 2 : set=set_tile_spacing
var mode:int = MODE_DRAW

var _mouse_pos:Vector2 = Vector2.ZERO
var _start_tile_pos:Vector2 = Vector2.ZERO
var _tile_pos:Vector2 = Vector2.ZERO : set=set_tile_pos
var _mouse_inside:bool = false
var _drawing:bool = false


func _ready() -> void:
	_populate_tile_grid()
	_init_tile_scale_spinbox()
	_init_tile_spacing_spinbox()
	_init_mode_btn_signals()
	set_mode(0)
	set_tile_scale(0.8)
	set_tile_spacing(2)
	Project.tiles.tiles_updated.connect(_populate_tile_grid)
	Project.map.tile_attrib_updated.connect(_populate_tile_grid)

func _process(delta: float) -> void:
	if !_mouse_inside:
		return
	
	_mouse_pos = scroll_container.get_local_mouse_position()
	_tile_pos = Vector2(
		int((_mouse_pos.x + scroll_container.scroll_horizontal) / ((MAP_TILE_SIZE * tile_scale) + tile_spacing_input.value)),
		int((_mouse_pos.y + scroll_container.scroll_vertical) / ((MAP_TILE_SIZE * tile_scale) + tile_spacing_input.value)),
	)
	
	if _drawing:
		if mode == MODE_DRAW:
			Project.map.set_tile(_tile_pos.x, _tile_pos.y, Context.selected_tile_index)
		if mode == MODE_HFLIP:
			var flip = !Project.map.get_tile_h_flip(_tile_pos.x, _tile_pos.y)
			
			Project.map.set_tile_h_flip(_tile_pos.x, _tile_pos.y, flip)
		if mode == MODE_VFLIP:
			var flip = !Project.map.get_tile_v_flip(_tile_pos.x, _tile_pos.y)
			
			Project.map.set_tile_v_flip(_tile_pos.x, _tile_pos.y, flip)
		
	#queue_redraw()

func _draw() -> void:
	var r = Rect2(
		Vector2(
			_tile_pos.x * (MAP_TILE_SIZE + tile_spacing_input.value),
			_tile_pos.y * (MAP_TILE_SIZE + tile_spacing_input.value) + 38
		),
		Vector2(64, 64)
	)

	#draw_rect(r, Color.RED, false, 2.0)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_drawing = event.pressed

func set_tile_spacing(new_space:int):
	tile_spacing = new_space
	
	if grid_container:
		grid_container.add_theme_constant_override("h_separation", tile_spacing)
		grid_container.add_theme_constant_override("v_separation", tile_spacing)
	
	if tile_spacing_input:
		tile_spacing_input.value = tile_spacing

func set_tile_scale(scale:float):
	tile_scale = scale
	if grid_container:
		_populate_tile_grid()

func set_mode(new_mode):
	mode = new_mode
	for child in mode_btns.get_children():
		child.button_pressed = mode == child.get_index()

func _init_mode_btn_signals():
	for child in mode_btns.get_children():
		child.pressed.connect(set_mode.bind(child.get_index()))

func _populate_tile_grid():
	grid_container.columns = Project.map.size.x
	
	for child in grid_container.get_children():
		child.queue_free()
	
	for tile in Project.map.get_tile_attribs():
		var tile_tex:TileTexture = TILE_TEXTURE.instantiate()
		tile_tex.tile = Project.tiles.get_tile(tile.tile_index)
		tile_tex.palette_bank = tile.palette_bank_index
		tile_tex.custom_minimum_size = Vector2(MAP_TILE_SIZE * tile_scale, MAP_TILE_SIZE * tile_scale)
		tile_tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tile_tex.flip_h = tile.h_flip
		tile_tex.flip_v = tile.v_flip
		
		grid_container.add_child(tile_tex)

func _init_tile_scale_spinbox():
	tile_scale_input.value = tile_scale

func _on_spin_box_value_changed(value: float) -> void:
	tile_scale = value

func _init_tile_spacing_spinbox():
	tile_spacing_input.value = tile_scale

func _on_tile_spacing_input_value_changed(value: float) -> void:
	tile_spacing = value

func _on_grid_container_mouse_entered() -> void:
	_mouse_inside = true

func _on_grid_container_mouse_exited() -> void:
	_mouse_inside = false

func set_tile_pos(new_pos):
	_tile_pos = new_pos
	if mouse_pos_label:
		mouse_pos_label.text = str(new_pos)
