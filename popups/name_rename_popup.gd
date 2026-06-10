class_name NameRenamePopup
extends Window


signal name_submitted(new_name:String)

@onready var message_lbl: Label = %messagelbl
@onready var new_name_input: LineEdit = %new_name_input
@onready var create_tileset_btn: Button = %confirm_btn

var message:String = ''
var old_name:String = ''
var accept_text:String = 'OK'


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	message_lbl.text = message
	new_name_input.placeholder_text = old_name
	create_tileset_btn.text = accept_text

	visibility_changed.connect(
		func():
			message_lbl.text = message
			new_name_input.placeholder_text = old_name
			new_name_input.text = ''
			create_tileset_btn.text = accept_text
	)

func _on_confirm_btn_pressed() -> void:
	name_submitted.emit(new_name_input.text)
	hide()

func _on_cancel_btn_pressed() -> void:
	name_submitted.emit(old_name)
	hide()
