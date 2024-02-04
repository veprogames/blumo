class_name CurrencyCounter
extends HBoxContainer

@onready var texture_rect_currency: TextureRect = $TextureRectCurrency
@onready var label_value: Label = $LabelValue

@export var texture: Texture2D : set = _set_texture
@export var value: float = 0.0 : set = _set_value

var is_ready: bool = false

func _ready() -> void:
	is_ready = true

func _set_texture(new_texture: Texture2D) -> void:
	texture = new_texture
	
	if not is_ready:
		await ready
	texture_rect_currency.texture = texture

func _set_value(new_value: float) -> void:
	value = new_value
	
	if not is_ready:
		await ready
	label_value.text = "%.0f" % value
