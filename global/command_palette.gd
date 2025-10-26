extends Node


signal commands_updated()

var commands:Dictionary = {}


func register_command(cmd_name:String, args:Array[Dictionary], callback:Callable):
	commands[cmd_name] = Command.new(args, callback)
	commands_updated.emit()

func call_command(command:String, ...args):
	var cmd_data:Command = commands.get(command)
	if !cmd_data:
		printerr('command does not exist ', command)
		return
	
	var c = cmd_data.callable

	var typed_args = _get_typed_args_array(cmd_data.args, args)

	var err = await c.callv(typed_args)
	if !err:
		printerr('error executing command.')
		return
	

func get_commands() -> Dictionary:
	return commands

func _get_typed_args_array(cmd_args:Array[Dictionary], passed_args):
	var ret = []
	
	for i in range(passed_args.size()):
		match cmd_args[i].type:
			TYPE_INT:
				ret.append(int(passed_args[i]))
			TYPE_STRING:
				ret.append(str(passed_args[i]))
	
	return ret

class Command:
	var args:Array[Dictionary]
	var callable:Callable

	func _init(c_args:Array[Dictionary], callback:Callable) -> void:
		args = c_args
		callable = callback
		
