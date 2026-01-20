extends GBEditPlugin


var editor

func _enter_tree() -> void:
	editor = instance_scene_at_path('res://plugins/map_editor/map_editor.tscn', 'res://plugins/map_editor/map_editor.gd')
	Ui.get_container(Ui.MAIN_CONTAINER).add_child(editor)
	
	_register_commands()



func _register_commands():
	pass
