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
var upgrade_triangle_chance: Upgrade = Upgrade.new(
	preload("res://assets/upgrade_definitions/triangle_chance.tres")
)
var upgrade_hexagon_chance: Upgrade = Upgrade.new(
	preload("res://assets/upgrade_definitions/hexagon_chance.tres")
)
var upgrade_star_chance: Upgrade = Upgrade.new(
	preload("res://assets/upgrade_definitions/star_chance.tres")
)
var upgrade_bullets_enable: Upgrade = Upgrade.new(
	preload("res://assets/upgrade_definitions/bullets_enable.tres")
)
var upgrade_bullets_firerate: Upgrade = Upgrade.new(
	preload("res://assets/upgrade_definitions/bullets_firerate.tres")
)
var upgrade_bullets_count: Upgrade = Upgrade.new(
	preload("res://assets/upgrade_definitions/bullets_count.tres")
)
var upgrade_magnet_enable: Upgrade = Upgrade.new(
	preload("res://assets/upgrade_definitions/magnet_enable.tres")
)
var upgrade_magnet_size: Upgrade = Upgrade.new(
	preload("res://assets/upgrade_definitions/magnet_size.tres")
)
var upgrade_magnet_strength: Upgrade = Upgrade.new(
	preload("res://assets/upgrade_definitions/magnet_strength.tres")
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
		"upgrade_triangle_chance": upgrade_triangle_chance.level,
		"upgrade_hexagon_chance": upgrade_hexagon_chance.level,
		"upgrade_star_chance": upgrade_star_chance.level,
		"upgrade_bullets_enable": upgrade_bullets_enable.level,
		"upgrade_bullets_firerate": upgrade_bullets_firerate.level,
		"upgrade_bullets_count": upgrade_bullets_count.level,
		"upgrade_magnet_enable": upgrade_magnet_enable.level,
		"upgrade_magnet_size": upgrade_magnet_size.level,
		"upgrade_magnet_strength": upgrade_magnet_strength.level,
	}


func load_game(serialized: Dictionary) -> void:
	stage = serialized.stage
	score = serialized.score
	upgrade_trail_length.level = serialized.upgrade_trail_length
	upgrade_edible_value.level = serialized.upgrade_edible_value
	upgrade_triangle_chance.level = serialized.upgrade_triangle_chance
	upgrade_hexagon_chance.level = serialized.upgrade_hexagon_chance
	upgrade_star_chance.level = serialized.upgrade_star_chance
	upgrade_bullets_enable.level = serialized.upgrade_bullets_enable
	upgrade_bullets_firerate.level = serialized.upgrade_bullets_firerate
	upgrade_bullets_count.level = serialized.upgrade_bullets_count
	upgrade_magnet_enable.level = serialized.upgrade_magnet_enable
	upgrade_magnet_size.level = serialized.upgrade_magnet_size
	upgrade_magnet_strength.level = serialized.upgrade_magnet_strength
