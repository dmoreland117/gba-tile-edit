class_name PaletteBankContainer
extends PanelContainer


signal color_selected(bank, idx)

@onready var color_container: HFlowContainer = %HFlowContainer
@onready var label: Label = $HBoxContainer/Label

var colors:Array[Color] = [] : set=set_colors
var bank:int = 0


func _ready() -> void:
	_draw_colors()
	label.text = str(bank)

func set_colors(val):
	colors = val
	
	if color_container:
		_draw_colors()

func _draw_colors():
	for child in color_container.get_children():
		child.queue_free()
	
	for color_idx in range(colors.size()):
		var cb = ColorPickerButton.new()
		cb.color = colors[color_idx]
		cb.custom_minimum_size = Vector2(32, 32)
		cb.pressed.connect(
			func():
				_on_color_selected(color_idx)
				cb.get_popup().hide()
		)
		
		if bank == Context.selected_palette_bank and color_idx == Context.selected_palette_idx:
			cb.button_pressed = true
			
		color_container.add_child(cb)

func _on_color_selected(idx):
	color_selected.emit(bank, idx)
