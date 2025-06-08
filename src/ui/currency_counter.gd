class_name CurrencyCounter
extends HBoxContainer

@onready var texture_rect_currency: TextureRect = $TextureRectCurrency
@onready var label_value: Label = $LabelValue

@export var texture: Texture2D : set = _set_texture
@export var value: float = 0.0 : set = _set_value

@export_category("Interpolation")
@export var interpolation_enabled: bool = false
@export var interpolation_time: float = 0.4

var displayed_value: float = 0.0


func _process(delta: float) -> void:
	if not interpolation_enabled:
		return
	
	displayed_value = lerp(displayed_value, value, delta * 10)
	displayed_value = move_toward(displayed_value, value, delta * 100)
	label_value.text = Utils.format_number(displayed_value)


func _set_texture(new_texture: Texture2D) -> void:
	texture = new_texture
	
	if not is_node_ready():
		await ready
	
	texture_rect_currency.texture = texture


func _set_value(new_value: float) -> void:
	value = new_value
	
	if not is_node_ready():
		await ready
	
	if not interpolation_enabled:
		label_value.text = Utils.format_number(value)


func set_value_instant(new_value: float) -> void:
	value = new_value
	displayed_value = new_value
