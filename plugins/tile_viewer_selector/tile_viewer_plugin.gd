extends GBEditPlugin


const TILES_CONTAINER = preload("uid://btej4pvrnpkp2")


func _enter_tree() -> void:
	var tc = TILES_CONTAINER.instantiate()
	Ui.get_container(Ui.RIGHT_CONTAINER).add_child(tc)
