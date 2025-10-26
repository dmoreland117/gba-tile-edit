extends MarginContainer

@onready var tab_bar: TabBar = %TabBar
@onready var menu: MenuBar = %menu
@onready var tab_bar_container: CenterContainer = %tab_bar_container
@onready var top_right_container: HBoxContainer = %top_right_container
@onready var left_container: TabContainer = %left_container
@onready var main_container: VBoxContainer = %main_container
@onready var right_container: TabContainer = %right_container


func _ready() -> void:
	register_ui_containers()

func register_ui_containers():
	Ui.register_container(Ui.TOP_RIGHT_CONTIANER, top_right_container)
	Ui.register_container(Ui.LEFT_CONTAINER, left_container)
	Ui.register_container(Ui.MAIN_CONTAINER, main_container)
	Ui.register_container(Ui.RIGHT_CONTAINER, right_container)
	
	Ui.register_menu_bar(menu)
	Ui.register_tab_bar(tab_bar)
