class_name SaveGame
extends Resource

signal stage_changed(new_stage: int)
signal score_changed(new_score: float)

var stage: int = 0 : set = _set_stage
var score: float = 0.0 : set = _set_score

var upgrade_trail_length: Upgrade = Upgrade.new(
	preload("res://assets/upgrade_definitions/trail_length.tres")
)
var upgrade_edible_value: Upgrade = Upgrade.new(
	preload("res://assets/upgrade_definitions/edible_value.tres")
)

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
