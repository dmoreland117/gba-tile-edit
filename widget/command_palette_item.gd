class_name CammandPaletteItem
extends PanelContainer

const ARG_CONTAINER = preload("uid://c15rfpw83as42")

@onready var cmd_name_label: Label = %cmd_name_label
@onready var args_container: HBoxContainer = %args_container

var cmd_name:String = ''
var cmd_args:Array[Dictionary]


func _ready() -> void:
	cmd_name_label.text = cmd_name
	
	for arg in cmd_args:
		var inst = ARG_CONTAINER.instantiate()
		inst.arg = arg
		
		args_container.add_child(inst)
