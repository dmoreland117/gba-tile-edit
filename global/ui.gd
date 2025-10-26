extends Node


var _menubar:MenuBar
var _tab_bar:TabBar

var containers = []

enum {
	TOP_RIGHT_CONTIANER,
	LEFT_CONTAINER,
	MAIN_CONTAINER,
	RIGHT_CONTAINER,
	
	CONTAINERS_SIZE
}

func _ready() -> void:
	containers.resize(CONTAINERS_SIZE)

func register_container(container:int, node:Control):
	containers[container] = node
	if container == MAIN_CONTAINER:
		node.child_order_changed.connect(_update_main_tabbar)

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

func get_menu_bar():
	return _menubar

func get_tab_bar():
	return _tab_bar

func get_container(container:int) -> Control:
	return containers[container]
