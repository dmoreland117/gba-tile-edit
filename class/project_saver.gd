class_name ProjectSaver


const FILE_EXTENTSION = 'gbproj'
const FILE_VERSION = 'v1.0'

const VERSION_WHITELIST = [
	'v1.0'
]


static func save_project_file(path:String):
	if path.get_extension() != FILE_EXTENTSION:
		return
	
	Project.last_save_path = path
	
	var proj_file_dict = {
		'version': FILE_VERSION,
		'name': Project.proj_name,
		'system_id': '',
		'palettes': [
			{
				'name': '',
				'mode': 'picker',
				'bank_size': 16,
				'fixed_palette': [],
				'colors': []
			}
		],
		'tilesets': [
			{
				'name': '',
				'tiles': [
					[0, 1, 0, 3, '...']
				]
			}
		],
		'tilemaps': [
			{
				'name': '',
				'size': {
					'x': 32, 'y': 32
				},
				"attributes": [
					{
						"idx": 1,
						"palette_idx": 0,
						"h_flip": false,
						"v_flip": true
					},
					'...'
				]
			}
		],
		'context': {
			'selected_palette_index': Context.selected_palette_index,
			'selected_palette_bank': Context.selected_palette_bank,
			'selected_tile_index': Context.selected_tile_index,
			'selected_tabs': {
				'left_panel': Context.selected_left_tab,
				'right_panel': Context.selected_right_tab,
				'main_panel': Context.selected_main_tab
			}
		}
	}
	
	
	
	pass

static func load_project_file(path:String) -> void:
	if path.get_extension() != FILE_EXTENTSION:
		return
	
	if !FileAccess.file_exists(path):
		return
	
	var proj_file_str = FileAccess.get_file_as_string(path)
	if proj_file_str == '':
		return
	
	var proj_file_dict = JSON.parse_string(proj_file_str)
	if !proj_file_dict:
		return
	
	var proj_file_version = proj_file_dict.get('version')
	if !proj_file_version:
		return
	
	if !VERSION_WHITELIST.has(proj_file_version):
		return
	
	if proj_file_version != FILE_VERSION:
		proj_file_dict = convert_old_file(proj_file_version)
	
	Project.proj_name = proj_file_dict.get('name', 'ERROR')
	Project.last_save_path = path

static func convert_old_file(old_version:String) -> Dictionary:
	return {}
	
