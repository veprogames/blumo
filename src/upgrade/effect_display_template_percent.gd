class_name EffectDisplayTemplatePercent
extends EffectDisplayTemplateBase

@export var precision: int = 0


func get_value(for_effect: float) -> String:
	for_effect *= 100.0
	var template: String = "%%.%df" % precision
	return (template % for_effect) + " %"
