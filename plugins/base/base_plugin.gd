extends GBEditPlugin


const PALETTE_EDITOR = preload('uid://w3ut3j5wah08')

var palette_editor_instance


func _enter_tree() -> void:
	#init palette editor
	palette_editor_instance = PALETTE_EDITOR.instantiate()
	Ui.get_container(Ui.LEFT_CONTAINER).add_child(palette_editor_instance)
	
	_register_commands()
	pass

func _register_commands():
	register_command('newpalette', [{'name': 'pal_name', 'type': TYPE_STRING}], add_palette)

func add_palette(pal_name:String):
	var pal = RGBPaletteData.new()
	pal.set_palette_name(pal_name)
	Project.palettes.add_palette(pal)
