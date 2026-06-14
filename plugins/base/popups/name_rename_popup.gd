class_name NameRenamePopup
extends Popup


signal name_submitted(new_name:String)

@onready var message_lbl: Label = %messagelbl
@onready var new_name_input: LineEdit = %new_name_input
@onready var create_tileset_btn: Button = %confirm_btn

var message:String = '' :
	set(val):
		message = val
		
		if !message_lbl:
			return
		
		message_lbl.text = val
var old_name:String = '' :
	set(val):
		old_name = val
		
		if !new_name_input:
			return
		
		new_name_input.placeholder_text = val
var accept_text:String = 'OK' :
	set(val):
		accept_text = val
		
		if !create_tileset_btn:
			return
		
		create_tileset_btn.text = val


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
	
	new_name_input.grab_focus()

func _on_confirm_btn_pressed() -> void:
	name_submitted.emit(new_name_input.text)
	hide()

func _on_cancel_btn_pressed() -> void:
	hide()

func _on_new_name_input_text_submitted(new_text: String) -> void:
	name_submitted.emit(new_text)
	hide()
