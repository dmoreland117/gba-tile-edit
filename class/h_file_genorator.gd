class_name HFileGenerator


static func generate_h_file_string(
	values:Array[String], arr_size:int, arr_type:String = 'const unsigned short', arr_name:String = 'untitled', h_gard_name:String = 'UNTITLED'
	) -> String:
	var ret_lines = []
	
	var current_line = ''
	
	current_line += '%s %s[%d];' % [arr_type, arr_name, arr_size]
	
	
	return ret_lines
