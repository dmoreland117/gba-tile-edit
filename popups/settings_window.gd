extends Window

@onready var categories_list: VBoxContainer = %categories_list
@onready var settings_list: VBoxContainer = %settings_list

var selected_category:int = 0


func _ready() -> void:
	_populate_categories()
	visibility_changed.connect(_on_visible)

func _on_visible():
	_populate_categories()
	_populate_settings_list()

func _populate_categories():
	for child in categories_list.get_children():
		categories_list.remove_child(child)
		child.queue_free()
	
	for cat in Settings.get_categories():
		var btn = Button.new()
		btn.text = cat
		btn.toggle_mode = true
		
		categories_list.add_child(btn)
		
		var i = btn.get_index()
		var pressed = btn.get_index() == selected_category
		btn.button_pressed = pressed
		
		btn.pressed.connect(
			func():
				selected_category = btn.get_index()
				_populate_categories()
				_populate_settings_list()
		)

func _populate_settings_list():
	var cats = Settings.get_categories()
	
	var settings_dict = Settings.get_sub_category_settings(
			cats[selected_category]
		)
	
	for child in settings_list.get_children():
		categories_list.remove_child(child)
		child.queue_free()
	
	for setting in settings_dict.keys():
		var hbox = HBoxContainer.new()
		
		var lbl = Label.new()
		lbl.text = setting
		var line_edit = LineEdit.new()
		line_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		line_edit.text = str(settings_dict[setting].value)
		hbox.add_child(lbl)
		hbox.add_child(line_edit)
		
		settings_list.add_child(hbox)
	
	

func _on_close_requested() -> void:
	hide()
