class_name PopupManager


static var _popup_scenes:Dictionary[String, PackedScene] = {}
static var _popups_container:Control


static func register_popups_container(container:Control):
	_popups_container = container
	
	Log.debug('Registered popups container', container)

static func register_popup(popup_id:String, scene:PackedScene):
	_popup_scenes.set(popup_id, scene)
	
	Log.debug('Registered popup with id:', popup_id)

static func remove_popup(popup_id:String) -> bool:
	return _popup_scenes.erase(popup_id)

static func show_popup(popup_id:String, properties:Dictionary[String, Variant] = {}) -> Popup:
	if !_popups_container:
		Log.warn('_popups_container is null')
		return
	
	var popup_scene:PackedScene = _popup_scenes.get(popup_id)
	var instance:Popup = popup_scene.instantiate()
	
	for property in properties.keys():
		instance.set(property, properties.get(property))
	
	Log.pr('Showing popup id:', popup_id)
	
	instance.popup_hide.connect(
		func():
			Log.debug('Removing popup with id:', popup_id)
			
			instance.queue_free()
	)
	
	_popups_container.add_child(instance)
	instance.popup_centered()
	
	return instance

static func show_file_dialouge(mode:FileDialog.FileMode, filters:PackedStringArray = [], title:String = '') -> FileDialog:
	var fd = FileDialog.new()
	fd.use_native_dialog = true
	fd.title = title
	fd.file_mode = mode
	fd.filters = filters
	
	Log.pr('Showing File popup')
	
	_popups_container.add_child(fd)
	fd.popup_centered()
	
	return fd
