extends Node


signal command_added(command:Command)
signal command_removed(cmd_name:String)
signal commands_updated()

var commands:Dictionary[String, Command] = {}


func register_command(cmd_name:String, args:Array[Dictionary], callback:Callable):
	var cmd = Command.new(args, callback)
	commands[cmd_name] = cmd
	command_added.emit(cmd)
	commands_updated.emit()

func remove_command(cmd_name:String):
	if !commands.erase(name):
		Log.err('Command', cmd_name, 'does not exist')
	
	command_removed.emit(cmd_name)

func call_command(command:String, ...args):
	var cmd_data:Command = commands.get(command)
	if !cmd_data:
		Log.err('Command', command, 'does not exist')
		return
	
	var c = cmd_data.callable

	var typed_args = _get_typed_args_array(cmd_data.args, args)

	var err = await c.callv(typed_args)
	if !err:
		Log.err('Command did not execute succesfully.')
		return

func get_commands() -> Dictionary[String, Command]:
	return commands

func get_command_names() -> PackedStringArray:
	return commands.keys()

func _get_typed_args_array(cmd_args:Array[Dictionary], passed_args):
	var ret = []
	
	for i in range(passed_args.size()):
		match cmd_args[i].type:
			TYPE_INT:
				ret.append(int(passed_args[i]))
			TYPE_STRING:
				ret.append(str(passed_args[i]))
			TYPE_VECTOR2I:
				var arg:String = str(passed_args[i]).remove_chars(' ')
				var arg_split:Array = arg.remove_chars('()').split(',')
				var vec2_xy_arr = arg_split.map(
					func(e):
						return int(e)
				)
				
				ret.append(Vector2i(
					vec2_xy_arr[0], vec2_xy_arr[1]
				))
	
	return ret
