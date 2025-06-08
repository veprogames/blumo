class_name EffectDisplayTemplate
extends EffectDisplayTemplateBase

@export var precision: int = 2
@export var prefix: String = ""
@export var suffix: String = ""


func get_value(for_effect: float) -> String:
	var template: String = "%%s%%.%df%%s" % precision
	return template % [prefix, for_effect, suffix]
