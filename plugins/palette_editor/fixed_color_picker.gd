class_name FixedColorPicker
extends HFlowContainer


signal selected_color_changed(idx)


var selected_color_idx:int = 0


func _ready() -> void:
	draw_colors()

func draw_colors():
	if Project.palette.mode == GBPalette.PALETTE_MODE_RGB:
		return
	
	for color in Project.palette.fixed_color_palette:
		var cb = ColorPickerButton.new()
		cb.custom_minimum_size = Vector2(32, 32)
		cb.color = color
		add_child(cb)
		cb.pressed.connect(
			func():
				selected_color_changed.emit(cb.get_index())
		)
	
