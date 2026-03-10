extends Control


@export var texture:TileTexture
@export var data:GridData


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _draw() -> void:
	var w_unit = texture.size.x / texture.get_width()
	var h_unit = texture.size.y / texture.get_height()
	
	var w_line_count = texture.size.x / w_unit
	var h_line_count = texture.size.y / h_unit
	
	for line in w_line_count:
		var start_pos = Vector2(line * w_unit, 0)
		var end_pos = Vector2(line * w_unit, size.y)
		
		draw_line(start_pos, end_pos, Color.RED, 2.0)
	for line in h_line_count:
		var start_pos = Vector2(0, line * w_unit)
		var end_pos = Vector2(size.x, line * w_unit)
		
		draw_line(start_pos, end_pos, Color.RED, 2.0)
