extends OptionButton


func _ready() -> void:
	clear()
	_populate_list()
	selected = 0
	
	Exporter.export_plugins_updated.connect(refresh_list)

func _populate_list():
	for exporter in Exporter.get_exporter_names():
		add_item(exporter)

func refresh_list():
	var old_selected = selected
	
	clear()
	_populate_list()
	
	var clamped_item_count = clamp(item_count - 1, 0, item_count)
	if clamped_item_count < old_selected:
		select(clamp(old_selected, 0, clamped_item_count))
