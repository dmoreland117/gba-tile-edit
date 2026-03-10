extends PanelContainer
class_name ToolBar

@onready var hbox: HBoxContainer = %hbox

var control_types:Dictionary[String, Dictionary] = {
	'button': {
		'draw': _draw_button,
		'update': _update_button
	}
}


func add_group(id:int = -1):
	pass

func add_button(id:int, text:String):
	pass

func _ready() -> void:
	pass # Replace with function body.

func _draw_button(params:Dictionary, toolbar) -> Control:
	return
	
func _update_button(control:Control, params):
	pass
	
	
