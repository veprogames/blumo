class_name SaveGame
extends Resource

signal stage_changed(new_stage: int)
signal score_changed(new_score: float)

@export var stage: int = 0 : set = _set_stage
@export var score: float = 0.0 : set = _set_score

@export var upgrade_trail_length: Upgrade = preload("res://global/upgrades/trail_length.tres").duplicate(true)
@export var upgrade_edible_value: Upgrade = preload("res://global/upgrades/edible_value.tres").duplicate(true)

func _set_stage(new_stage: int) -> void:
	stage = new_stage
	stage_changed.emit(stage)

func _set_score(new_score: float) -> void:
	score = new_score
	score_changed.emit(score)

func serialize() -> Dictionary:
	return {
		"stage": stage,
		"score": score,
		"upgrade_trail_length": upgrade_trail_length.level,
		"upgrade_edible_value": upgrade_edible_value.level,
	}

func load_game(serialized: Dictionary) -> void:
	stage = serialized.stage
	score = serialized.score
	upgrade_trail_length.level = serialized.upgrade_trail_length
	upgrade_edible_value.level = serialized.upgrade_edible_value
