class_name Upgrade
extends Resource

signal leveled_up()

@export var level: int = 0

@export var price_formula: String:
	set(formula):
		price_formula = formula
		if price_expression.parse(price_formula, ["level"]) != OK:
			push_warning(
				"Parsing Formula for Upgrade %s failed: %s" % [
					self,
					price_expression.get_error_text()
				]
			)
var price_expression: Expression = Expression.new()

@export var effect_formula: String:
	set(formula):
		effect_formula = formula
		if effect_expression.parse(effect_formula, ["level"]) != OK:
			push_warning(
				"Parsing Formula for Upgrade %s failed: %s" % [
					self,
					effect_expression.get_error_text()
				]
			)
var effect_expression: Expression = Expression.new()

@export var effect_display: EffectDisplayTemplate

func get_effect_display() -> String:
	return effect_display.get_value(get_current_effect())

func get_current_price() -> float:
	var value: Variant = price_expression.execute([level])
	if price_expression.has_execute_failed() or value == null:
		return 0
	return value

func get_current_effect() -> float:
	var value: Variant = effect_expression.execute([level])
	if effect_expression.has_execute_failed() or value == null:
		return 0
	return value

func can_buy_with(resource: float) -> bool:
	return get_current_price() <= resource

func try_buy(with_resource: float) -> Variant:
	if can_buy_with(with_resource):
		var price: float = get_current_price()
		var deducted: float = price
		level += 1
		
		leveled_up.emit()
		
		return deducted
	return null
