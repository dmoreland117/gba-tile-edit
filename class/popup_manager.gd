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

static func show_popup(popup_id:String) -> Popup:
	if !_popups_container:
		Log.warn('_popups_container is null')
		return
	
	var popup_scene:PackedScene = _popup_scenes.get(popup_id)
	var instance:Popup = popup_scene.instantiate()
	
	Log.pr('Showing popup id:', popup_id)
	
	instance.popup_hide.connect(
		func():
			Log.debug('Removing popup with id:', popup_id)
			
			instance.queue_free()
	)
	
	_popups_container.add_child(instance)
	instance.popup_centered()
	
	return instance
