extends Control


@export var texture:TileTexture
@export var data:GridData : set=set_data


func set_data(new_data:GridData):
	data = new_data
	data.data_updated.connect(
		func():
			queue_redraw()
	)

func _ready() -> void:
	set_data(data)


func _draw() -> void:
	if !data:
		return
	
	if !data.show_grid:
		return
	
	var w_unit = (texture.size.x / texture.get_width()) * data.spacing_px.x
	var h_unit = (texture.size.y / texture.get_height()) * data.spacing_px.y
	
	var w_line_count = texture.size.x / w_unit
	var h_line_count = texture.size.y / h_unit
	
	for line in w_line_count:
		var start_pos = Vector2(line * w_unit, 0)
		var end_pos = Vector2(line * w_unit, size.y)
		
		draw_line(start_pos, end_pos, data.color, 2.0)
	for line in h_line_count:
		var start_pos = Vector2(0, line * w_unit)
		var end_pos = Vector2(size.x, line * w_unit)
		
		draw_line(start_pos, end_pos, data.color, data.line_thickness_px)
