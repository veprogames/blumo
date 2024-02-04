class_name UpgradeButton
extends Control

@onready var button_buy: TextureButton = $ButtonBuy
@onready var currency_cost: CurrencyCounter = $CurrencyCost
@onready var label_effect: Label = $LabelEffect
@onready var label_effect_title: Label = $LabelEffectTitle

@export_enum("upgrade_trail_length") var property: String

@export var icon: Texture2D
@export var effect_text: String

var upgrade: Upgrade

func _ready() -> void:
	upgrade = get_upgrade() as Upgrade
	
	if upgrade != null:
		upgrade.leveled_up.connect(update_ui)
		label_effect_title.text = effect_text
		button_buy.texture_normal = icon
		button_buy.texture_hover = icon
		button_buy.texture_pressed = icon
	
	update_ui()

func get_upgrade() -> Variant:
	return Global.save.get(property)

func update_ui() -> void:
	if upgrade != null:
		label_effect.text = upgrade.get_effect_display()
		currency_cost.value = upgrade.get_current_price()

func _on_button_buy_pressed() -> void:
	var to_deduct: Variant = upgrade.try_buy(Global.save.score)
	if to_deduct != null:
		Global.save.score -= to_deduct
