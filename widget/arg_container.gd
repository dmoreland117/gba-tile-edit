class_name CmdArgContainer
extends PanelContainer


@onready var label: Label = %arg_label
@onready var arg_type: Label = %arg_type

var arg:Dictionary = {}


func _ready() -> void:
	label.text = arg.name
	arg_type.text = type_enum_to_type_String(arg.type)

func type_enum_to_type_String(type:int):
	var types = {
		TYPE_INT: 'int',
		TYPE_STRING: 'string'
	}
	
	return types.get(type, '')
