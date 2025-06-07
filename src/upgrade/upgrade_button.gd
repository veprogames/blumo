class_name UpgradeButton
extends Button

@onready var currency_cost: CurrencyCounter = %CurrencyCost
@onready var label_effect: Label = %LabelEffect
@onready var label_effect_title: Label = %LabelEffectTitle
@onready var texture_rect_icon: TextureRect = %TextureRectIcon
@onready var margin_container: MarginContainer = $MarginContainer
@onready var label_maxed: Label = $MarginContainer/VBoxContainer/LabelMaxed

var upgrade: Upgrade:
	set(upg):
		if not is_node_ready():
			await ready
		
		if upgrade and upgrade.level_changed.is_connected(_on_upgrade_level_changed):
			upgrade.level_changed.disconnect(_on_upgrade_level_changed)
		
		upgrade = upg
		label_effect_title.text = upgrade.definition.title
		texture_rect_icon.texture = upgrade.definition.icon
		upgrade.level_changed.connect(_on_upgrade_level_changed)
		
		update_ui()


func _ready() -> void:
	Global.save.score_changed.connect(_on_save_score_changed)


func update_ui() -> void:
	if upgrade != null:
		label_effect.text = upgrade.get_effect_display()
		
		if upgrade.is_maxed():
			label_maxed.show()
			currency_cost.hide()
		else:
			label_maxed.hide()
			currency_cost.show()
			currency_cost.value = upgrade.get_current_price()
		
		var can_buy: bool = upgrade.can_buy_with(Global.save.score)
		disabled = !can_buy
		texture_rect_icon.modulate.a = 0.125 if !can_buy else 0.25
		margin_container.modulate.a = 1.0 if can_buy else 0.5
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND if can_buy else Control.CURSOR_FORBIDDEN


func _on_save_score_changed(_score: float) -> void:
	update_ui()


func _on_upgrade_level_changed(_lvl: int) -> void:
	update_ui()


func _on_pressed() -> void:
	var to_deduct: Variant = upgrade.try_buy(Global.save.score)
	if to_deduct != null:
		Global.save.score -= to_deduct
		update_ui()
