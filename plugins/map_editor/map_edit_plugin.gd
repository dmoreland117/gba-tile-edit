extends GBEditPlugin

const MAP_EDITOR = preload("uid://b60wc5mnlvqpb")

var editor

func _enter_tree() -> void:
	editor = MAP_EDITOR.instantiate()
	Ui.get_container(Ui.MAIN_CONTAINER).add_child(editor)
	
	_register_commands()



func _register_commands():
	pass
