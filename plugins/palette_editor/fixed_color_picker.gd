class_name FixedColorPicker
extends HFlowContainer


signal color_changed(idx)


var selected_color_idx:int = 0
var colors = [] : set=set_colors


func set_colors(new_colors):
	colors = new_colors
	
	draw_colors()

func _ready() -> void:
	draw_colors()

func draw_colors():
	for color in colors:
		var cb = ColorPickerButton.new()
		cb.custom_minimum_size = Vector2(32, 32)
		cb.color = color
		add_child(cb)
		cb.pressed.connect(
			func():
				color_changed.emit(cb.get_index())
		)
	
