extends PopupPanel


@onready var system_preset_opt: OptionButton = %system_preset_opt


func _ready() -> void:
	_populate_system_preset_opt()
	PluginManager.system_presets_changed.connect(_populate_system_preset_opt)

func _populate_system_preset_opt():
	system_preset_opt.clear()
	
	for preset in PluginManager.get_system_presets():
		system_preset_opt.add_item(preset.get('name', 'Unnamed System'))

func _on_new_project_btn_pressed() -> void:
	Project.create_new_project(system_preset_opt.selected)
	hide()
