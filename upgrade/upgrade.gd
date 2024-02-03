class_name Upgrade
extends Resource

@export var level: int = 0
@export var price_formula: UpgradeFormula
@export var effect_formula: UpgradeFormula

func get_current_price() -> float:
	return price_formula.get_value(level)

func get_current_effect() -> float:
	return effect_formula.get_value(level)

func can_buy_with(resource: float) -> bool:
	return get_current_price() <= resource

func try_buy(with_resource: float) -> Variant:
	if can_buy_with(with_resource):
		var price: float = get_current_price()
		var deducted: float = price
		level += 1
		return deducted
	return null
