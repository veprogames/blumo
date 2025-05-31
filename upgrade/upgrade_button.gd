class_name UpgradeButton
extends Control

@onready var button_buy: TextureButton = $ButtonBuy
@onready var currency_cost: CurrencyCounter = $CurrencyCost
@onready var label_effect: Label = $LabelEffect
@onready var label_effect_title: Label = $LabelEffectTitle

@export var icon: Texture2D
@export var effect_text: String

var upgrade: Upgrade:
	set(upg):
		if not is_node_ready():
			await ready
		
		if upgrade != null:
			upgrade.leveled_up.disconnect(update_ui)
		
		upgrade = upg
		upgrade.leveled_up.connect(update_ui)
		label_effect_title.text = effect_text
		button_buy.texture_normal = icon
		button_buy.texture_hover = icon
		button_buy.texture_pressed = icon
		
		update_ui()

func update_ui() -> void:
	if upgrade != null:
		label_effect.text = upgrade.get_effect_display()
		currency_cost.value = upgrade.get_current_price()
		
		var can_buy: bool = upgrade.can_buy_with(Global.save.score)
		modulate = Color(1, 1, 1, 1.0 if can_buy else 0.5)
		button_buy.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND if can_buy else Control.CURSOR_FORBIDDEN
		

func _on_button_buy_pressed() -> void:
	var to_deduct: Variant = upgrade.try_buy(Global.save.score)
	if to_deduct != null:
		Global.save.score -= to_deduct
