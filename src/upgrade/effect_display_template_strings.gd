class_name EffectDisplayTemplateStrings
extends EffectDisplayTemplateBase

@export var values: Array[String]


func get_value(for_effect: float) -> String:
	var value: int = int(for_effect)
	return values[clampi(value, 0, values.size() - 1)]
