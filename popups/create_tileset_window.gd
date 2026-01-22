extends Window


@onready var tileset_name_input: LineEdit = %tileset_name_input
@onready var size_x_input: SpinBox = %size_x_input
@onready var size_y_input: SpinBox = %size_y_input


func _ready() -> void:
	size_x_input.value = 8
	size_y_input.value = 8


func _on_close_requested() -> void:
	hide()
	
	size_x_input.value = 8
	size_y_input.value = 8


func _on_create_tileset_btn_pressed() -> void:
	CommandPalette.call_command(
			'addtileset', 
			tileset_name_input.text, 
			Vector2i(size_x_input.value, size_y_input.value)
		)
	
	_on_close_requested()

func _on_cancel_btn_pressed() -> void:
	_on_close_requested()
