extends PanelContainer


signal value_changed(new_value)

@onready var zoom_slider: HSlider = %zoom_slider

@export var value:float = 1 : set=set_value
@export var min:float = 1
@export var max:float = 20
@export var step:float = 0.1


func set_value(new_value):
	value = new_value
	zoom_slider.value = new_value

func _ready() -> void:
	zoom_slider.value = value
	zoom_slider.min_value = min
	zoom_slider.max_value = max
	zoom_slider.step = step

func _on_reset_btn_pressed() -> void:
	value = min
	value_changed.emit(value)

func _on_zoom_slider_value_changed(new_value: float) -> void:
	value = new_value
	value_changed.emit(new_value)
	
