extends Node


var plugins:Array[GBEditPlugin]


func load_plugin(path:String) -> int:
	var p = load(path)
	var id = plugins.size()
	
	var pi = p.new()
	
	if pi is not GBEditPlugin:
		printerr('Not a plugin script.')
		return 0
	
	plugins.append(pi)
	add_child(pi)
	
	return id

func remove_plugin(idx:int):
	plugins[idx].queue_free()
	
