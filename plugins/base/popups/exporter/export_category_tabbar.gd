extends TabBar


var selected_exporter:ExportPlugin : set=set_selected_exporter


func set_selected_exporter(new_exporter:ExportPlugin):
	selected_exporter = new_exporter
	
	var old_current_tab = current_tab
	
	clear_tabs()
	_populate_bar()
	
	var clamped_current_tab = clamp(current_tab - 1, 0, tab_count)
	if old_current_tab > clamped_current_tab:
		current_tab = clamped_current_tab
		return
	
	current_tab = old_current_tab

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clear_tabs()
	_populate_bar()
	current_tab = 0

func _populate_bar():
	if !selected_exporter:
		return
	
	for cat in selected_exporter.get_supported_categories():
		add_tab(cat.capitalize())
