extends Label
class_name TemplateLabel


@export var replace:Dictionary[String, String] = {}

var _start_txt:String = ''

func _ready() -> void:
	_start_txt = text
	replace_text()

func replace_text():
	text = _start_txt.format(replace)
