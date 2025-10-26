extends Node


func int_array_to_c_char_array(values: PackedByteArray, name: String = "data", prefix_lines:PackedStringArray = []) -> String:
	var result := ""
	var line := ""
	
	for prefix in prefix_lines:
		result += prefix + '\n'
	
	result += '\n'
	
	result += "const char " + name + "[" + str(values.size()) + "] = {\n"
	
	for i in range(values.size()):
		# Ensure the value fits in 8 bits
		var value: int = values[i] & 0xFF
		line += "0x%02X" % value
		
		# Add comma unless last value
		if i < values.size() - 1:
			line += ", "
		
		# Wrap every 16 values for readability
		if (i + 1) % 16 == 0:
			result += "\t" + line + "\n"
			line = ""
	
	# Add any leftover values
	if line != "":
		result += "\t" + line + "\n"
	
	result += "};\n"
	return result
