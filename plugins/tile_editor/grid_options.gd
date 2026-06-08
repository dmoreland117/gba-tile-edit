extends VBoxContainer

@onready var grid_colorpicker_btn: ColorPickerButton = %grid_colorpicker_btn
@onready var spacing_x_input: SpinBox = %spacing_x_input
@onready var spacing_y_input: SpinBox = %spacing_y_input
@onready var thichness_input: SpinBox = %thickness_input

var grid_data:GridData

func _ready() -> void:
	if !grid_data:
		return
	
	grid_colorpicker_btn.color = grid_data.color
	spacing_x_input.value = grid_data.spacing_px.x
	spacing_y_input.value = grid_data.spacing_px.y
	thichness_input.value = grid_data.line_thickness_px

func _on_grid_colorpicker_btn_color_changed(color: Color) -> void:
	if grid_data:
		grid_data.color = color
	
		grid_data.data_updated.emit()


func _on_spacing_x_input_value_changed(value: float) -> void:
	if !grid_data:
		return
	
	grid_data.spacing_px.x = value
	grid_data.data_updated.emit()


func _on_spacing_y_input_value_changed(value: float) -> void:
	if !grid_data:
		return
	
	grid_data.spacing_px.y = value
	grid_data.data_updated.emit()


func _on_thickness_input_value_changed(value: float) -> void:
	if !grid_data:
		return
	
	grid_data.line_thickness_px = value
	grid_data.data_updated.emit()
