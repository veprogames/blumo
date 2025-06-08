class_name Upgrade
extends RefCounted

signal level_changed(lvl: int)
signal leveled_up

var level: int = 0:
	set(lvl):
		level = lvl
		level_changed.emit(lvl)

var definition: UpgradeDefinition


func _init(def: UpgradeDefinition) -> void:
	definition = def


func get_effect_display() -> String:
	return definition.effect_display.get_value(get_current_effect())


func get_current_price() -> float:
	var value: Variant = definition.price_expression.execute([level])
	if definition.price_expression.has_execute_failed() or value == null:
		return 0
	return value


func get_current_effect() -> float:
	var value: Variant = definition.effect_expression.execute([level])
	if definition.effect_expression.has_execute_failed() or value == null:
		return 0
	return value


func is_maxed() -> bool:
	return definition.max_level > 0 and level >= definition.max_level


func can_buy_with(resource: float) -> bool:
	return !is_maxed() and get_current_price() <= resource


func try_buy(with_resource: float) -> Variant:
	if can_buy_with(with_resource):
		var price: float = get_current_price()
		var deducted: float = price
		level += 1
		
		leveled_up.emit()
		GameEvents.emit_upgrade_bought(self)
		
		return deducted
	return null
