extends PopupPanel


const COMMAND_PALETTE_ITEM = preload("uid://c34gs4jas8a5h")

@onready var line_edit: LineEdit = %LineEdit
@onready var command_list: VBoxContainer = %command_list


func _ready() -> void:
	_draw_cmd_list()
	CommandPalette.commands_updated.connect(_draw_cmd_list)

func _draw_cmd_list():
	for child in command_list.get_children():
		child.queue_free()
	
	var commands = CommandPalette.get_commands()
	for command in CommandPalette.get_commands().keys():
		var b:CammandPaletteItem = COMMAND_PALETTE_ITEM.instantiate()
		b.cmd_name = command
		
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		b.cmd_args = CommandPalette.get_commands()[command].args
		
		
		
		command_list.add_child(b)

func _on_visibility_changed() -> void:
	_draw_cmd_list()
	line_edit.grab_focus()

func _on_line_edit_text_submitted(new_text: String) -> void:
	var split = new_text.split(' ')
	
	var command = split.get(0)
	if !command:
		return
	
	var args:Array = split.slice(1)
	
	CommandPalette.callv('call_command', [command] + args)
	
	hide()
