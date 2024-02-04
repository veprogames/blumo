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

var is_ready: bool = false

func _ready() -> void:
	is_ready = true
	
	if not interpolation_enabled:
		process_mode = Node.PROCESS_MODE_DISABLED

func _process(_delta: float) -> void:
	label_value.text = "%.0f" % displayed_value

func _set_texture(new_texture: Texture2D) -> void:
	texture = new_texture
	
	if not is_ready:
		await ready
	texture_rect_currency.texture = texture

func _set_value(new_value: float) -> void:
	value = new_value
	
	if not is_ready:
		await ready
	
	if interpolation_enabled:
		var tween: Tween = create_tween()
		tween.tween_property(self, ^"displayed_value", value, interpolation_time) \
			.set_ease(Tween.EASE_OUT) \
			.set_trans(Tween.TRANS_EXPO)
	else:
		label_value.text = "%.0f" % value
