extends PopupPanel


func _ready() -> void:
	pass

func _on_new_project_btn_pressed() -> void:
	Popups.show_new_project_window()

func _on_button_2_pressed() -> void:
	CommandPalette.call_command('load')
