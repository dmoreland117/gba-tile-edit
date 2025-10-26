extends Button


@onready var tile_texture: TileTexture = %tile_texture
@onready var label: Label = %Label


var tile:GBTileData


func _ready() -> void:
	label.text = str(get_index())
	tile_texture.tile = tile
