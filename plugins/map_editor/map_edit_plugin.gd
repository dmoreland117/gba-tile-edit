extends GBEditPlugin


var editor

func _enter_tree() -> void:
	editor = instance_scene_at_path('res://plugins/map_editor/map_editor.tscn', 'res://plugins/map_editor/map_editor.gd')
	Ui.get_container(Ui.MAIN_CONTAINER).add_child(editor)
	
	_register_commands()

func _register_commands():
	register_command(
		'addmap',
		[
			{
				'name': 'name',
				'type': TYPE_STRING
			},
			{
				'name': 'size',
				'type': TYPE_VECTOR2I
			},
		],
		_add_map
	)
	
func _add_map(map_name:String = '', size:Vector2i = Vector2i(32, 32)):
	var new_map = GBMapData.new(size)
	new_map.map_name = name
	Project.add_map(new_map)
	
	return true
