class_name ExportPropContainer
extends VBoxContainer

const TYPE_ENUM = 10000

var params:Dictionary = {} :
	set(val):
		params = val
		_draw_param_controls()
		
var parsed_params = {}


func _ready() -> void:
	_draw_param_controls()

func _draw_param_controls():
	parsed_params = {}
	
	for child in get_children():
		child.queue_free()
	
	var c:Control
	for param in params.keys():
		var hbox = HBoxContainer.new()
		
		var tt = params[param].get('tooltip', '')
		hbox.tooltip_text = tt
		
		var l = Label.new()
		l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		l.text = param
		
		hbox.add_child(l)
		match params[param].type:
			TYPE_ENUM:
				c = OptionButton.new()
				for opt in params[param].options:
					c.add_item(opt)
				
				c.select(params[param].default)
				
				parsed_params[param] = params[param].default
				c.item_selected.connect(
					func(idx):
						var on_changed = params[param].get('on_changed', null)
						if on_changed:
							on_changed.call(idx)
						
						parsed_params[param] = idx
				)
				
			TYPE_INT:
				c = SpinBox.new()
				
				c.value = params[param].default
				
				parsed_params[param] = params[param].default
				c.value_changed.connect(
					func(val):
						var on_changed:Callable = params[param].get('on_changed')
						if on_changed:
							on_changed.call(val)
						
						parsed_params[param] = int(val)
				)
				
			TYPE_STRING:
				c = LineEdit.new()
				
				c.text = params[param].default
				
				parsed_params[param] = params[param].default
				c.text_changed.connect(
					func(val):
						var on_changed = params[param].get('on_changed')
						if on_changed:
							on_changed.call(val)
						
						parsed_params[param] = val
				)
		
		c.custom_minimum_size = Vector2(180, 0)
		hbox.add_child(c)
		add_child(hbox)

func get_parsed_params() -> Dictionary:
	return parsed_params
