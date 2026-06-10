extends GBEditPlugin


const PALETTE_EDITOR = preload('uid://w3ut3j5wah08')
const TILE_EDITOR = preload('uid://btlvl3adq1x6g')

var palette_editor_instance:PaletteEditor
var tile_editor_instance:TileEditor


func _enter_tree() -> void:
	#init palette editor
	palette_editor_instance = PALETTE_EDITOR.instantiate()
	Ui.get_container(Ui.LEFT_CONTAINER).add_child(palette_editor_instance)
	
	tile_editor_instance = TILE_EDITOR.instantiate()
	tile_editor_instance.palette_editor = palette_editor_instance
	Ui.get_container(Ui.MAIN_CONTAINER).add_child(tile_editor_instance)
	
	_register_commands()
	pass

func _register_commands():
	register_command('newpalette', [{'name': 'pal_name', 'type': TYPE_STRING}], add_palette)

func add_palette(pal_name:String):
	var pal = RGBPaletteData.new()
	pal.set_palette_name(pal_name)
	Project.palettes.add_palette(pal)
