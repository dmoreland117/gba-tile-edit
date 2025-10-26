extends Node


var _settings:Dictionary = {}


func set_setting(value, setting_name:String, category:String, sub_category:String = '.'):
	var cat = _settings.get(category)
	if !cat:
		_settings[category] = {}
	
	var sub_cat = _settings[category].get(sub_category)
	if !sub_cat:
		_settings[category][sub_category] = {}
	
	_settings[category][sub_category][setting_name] = value

func get_setting(setting_name:String, category:String, sub_category:String = '.', default = null):
	var cat = _settings.get(category)
	if !cat:
		printerr('Category does not exist. ', category)
		return default
	
	var sub_cat = cat.get(sub_category)
	if !sub_cat:
		printerr('Sub Category does not exist. ', sub_category)
		return default
	
	var setting = sub_cat.get(setting_name)
	if setting == null:
		printerr('Setting does not exist. ', setting_name)
		return default
	
	return setting

func get_categories() -> PackedStringArray:
	var ret = PackedStringArray()
	
	for cat in _settings.keys():
		ret.append(cat)
	
	return ret

func get_sub_categories(category:String) -> PackedStringArray:
	var ret = PackedStringArray()
	
	var cat = _settings.get(category)
	if !cat:
		printerr('Category does not exist. ', category)
		return ret
	
	for scat in cat.keys():
		ret.append(scat)
	
	return ret

func has_setting(setting_name:String, category:String, sub_category:String = '.') -> bool:
	var cat = _settings.get(category)
	if !cat:
		return false
	
	var sub_cat = cat.get(sub_category)
	if !sub_cat:
		return false
	
	var setting = sub_cat.get(setting_name)
	if setting == null:
		return false
	
	return true

func save():
	var file = FileAccess.open('user://settings.json', FileAccess.WRITE)
	if !file:
		printerr('could not save settings')
		return
	
	var settings_dict = _settings
	file.store_string(str(settings_dict))
	file.close()

func load():
	var settings_str = FileAccess.get_file_as_string('user://settings.json')
	if settings_str.is_empty():
		return
	
	var settings_dict = JSON.parse_string(settings_str)
	if !settings_dict:
		return
	
	_settings = settings_dict
	
