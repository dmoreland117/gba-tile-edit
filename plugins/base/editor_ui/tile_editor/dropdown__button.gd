@tool
extends HBoxContainer


signal pressed()
signal toggled(toggled_on:bool)
signal dropdown_pressed()

@onready var main_button: Button = %main_button
@onready var dropdown_button: Button = %dropdown_button
@onready var popup_panel: PopupPanel = %PopupPanel

@export_multiline() var text:String = '' : set=set_text
@export var icon:Texture : set=set_icon
@export var toggle_mode:bool = false : set=set_toggle_mode

var button_pressed:bool = false : set=set_button_pressed


func set_button_pressed(press:bool):
	button_pressed = press
	
	if main_button:
		main_button.button_pressed = press

func set_toggle_mode(mode:bool):
	toggle_mode = mode
	if main_button:
		main_button.toggle_mode = toggle_mode

func set_text(txt:String):
	text = txt
	if main_button:
		main_button.text = text

func set_icon(new_icon:Texture):
	icon = new_icon
	if main_button:
		main_button.icon = icon

func get_popup() -> PopupPanel:
	return popup_panel

func _on_main_button_pressed() -> void:
	pressed.emit()

func _ready() -> void:
	set_text(text)
	set_icon(icon)
	set_toggle_mode(true)

func _on_dropdown_button_pressed() -> void:
	if popup_panel.visible:
		popup_panel.hide()
		return
		
	var pos := global_position
	pos.y += main_button.size.y
	popup_panel.popup(
		Rect2i(pos, Vector2i(200, 200))
	)
	
	if main_button:
		main_button.toggle_mode = toggle_mode
	
	dropdown_pressed.emit()

func _on_main_button_toggled(toggled_on: bool) -> void:
	button_pressed = toggled_on
	toggled.emit(toggled_on)
