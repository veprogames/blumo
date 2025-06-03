class_name UpgradeDefinition
extends Resource

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

@export var effect_display: EffectDisplayTemplateBase

@export var title: String
@export var icon: Texture2D
