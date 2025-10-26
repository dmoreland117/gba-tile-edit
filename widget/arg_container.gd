class_name CmdArgContainer
extends PanelContainer


@onready var label: Label = %arg_label

var arg:Dictionary = {}


func _ready() -> void:
	label.text = arg.name
