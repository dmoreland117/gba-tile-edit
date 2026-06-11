extends Node


var _menubar:MenuBar
var _tab_bar:TabBar
var _tile_editor:TileEditor

var containers = []

enum {
	TOP_RIGHT_CONTIANER,	# hbox container
	LEFT_CONTAINER,			# tab container
	MAIN_CONTAINER,
	RIGHT_CONTAINER,		# tab container
	
	CONTAINERS_SIZE
}

func _ready() -> void:
	containers.resize(CONTAINERS_SIZE)

func register_container(container:int, node:Control):
	containers[container] = node
	if container == MAIN_CONTAINER:
		node.child_order_changed.connect(_update_main_tabbar)
	if container == LEFT_CONTAINER:
		containers[container].tab_changed.connect(_update_context_selected_tabs)
	if container == RIGHT_CONTAINER:
		containers[container].tab_changed.connect(_update_context_selected_tabs)

func register_tile_editor(t:TileEditor):
	_tile_editor = t

func get_tile_editor() -> TileEditor:
	return _tile_editor

func _update_main_tabbar():
	_tab_bar.clear_tabs()
	
	for child in containers[MAIN_CONTAINER].get_children():
		_tab_bar.add_tab(child.name)
	
	for child in get_container(MAIN_CONTAINER).get_children():
		child.hide()
	
	var current_container = get_container(MAIN_CONTAINER).get_child(_tab_bar.current_tab)
	
	if current_container:
		current_container.show()

func register_menu_bar(node:MenuBar):
	_menubar = node

func register_tab_bar(node:TabBar):
	_tab_bar = node
	node.tab_changed.connect(_on_tab_changed)

func _on_tab_changed(idx):
	if !containers[MAIN_CONTAINER]:
		return
	
	for child in get_container(MAIN_CONTAINER).get_children():
		child.hide()
	
	get_container(MAIN_CONTAINER).get_child(idx).show()
	
	_update_context_selected_tabs()

func get_menu_bar() -> MenuBar:
	return _menubar

func get_tab_bar() -> TabBar:
	return _tab_bar

func get_container(container:int) -> Control:
	return containers[container]

func _update_context_selected_tabs(_tab:int = 0):
	pass
