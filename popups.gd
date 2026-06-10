class_name Popups
extends Control

@onready var welcome_popup: PopupPanel = %welcome_popup
@onready var command_palette_popup: PopupPanel = %command_palette_popup
@onready var save_file: FileDialog = %save_file
@onready var open_file: FileDialog = %open_file
@onready var settings_window: Window = %settings_Window
@onready var create_tileset_window: Window = $create_tileset_window
@onready var new_project_popup: PopupPanel = %new_project_popup
@onready var name_rename_popup: NameRenamePopup = %name_rename_popup

static var _instance:Popups


func _ready() -> void:
	_instance = self

static func show_welcome_popup():
	_instance.welcome_popup.popup_centered()

static func show_command_palette():
	_instance.command_palette_popup.popup_centered()

static func show_save_file_popup(filters:PackedStringArray) -> String:
	_instance.save_file.filters = filters
	_instance.save_file.popup_centered()
	
	return await _instance.save_file.file_selected

static func show_name_rename_popup(message, old_name, accept_text = 'OK') -> String:
	_instance.name_rename_popup.accept_text = accept_text
	_instance.name_rename_popup.message = message
	_instance.name_rename_popup.old_name = old_name
	_instance.name_rename_popup.popup_centered()
	
	return await _instance.name_rename_popup.name_submitted

static func show_open_file_popup(filters:PackedStringArray) -> String:
	_instance.open_file.filters = filters
	_instance.open_file.popup_centered()
	
	return await _instance.open_file.file_selected

static func show_settings_window():
	_instance.settings_window.popup_centered()

static func show_create_tileset_window():
	_instance.create_tileset_window.popup_centered()

static func show_new_project_window():
	_instance.new_project_popup.popup_centered()
