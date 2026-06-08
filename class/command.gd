class_name Command

var shortcut_mask:int
var show_in_menubar:int
var menubar_path:String
var args:Array[Dictionary]
var callable:Callable

func _init(c_args:Array[Dictionary], callback:Callable, shortcut:int = 0, show_menubar:bool = false, menu_path:String = '') -> void:
	args = c_args
	callable = callback
	shortcut_mask = shortcut
	show_in_menubar = show_menubar
	menubar_path = menubar_path
