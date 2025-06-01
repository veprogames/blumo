class_name EdibleSpawner
extends Node2D

signal edible_eaten()

@export var level: Level

var EdibleScene: PackedScene = preload("res://src/edible/edible.tscn")
var EdibleBehaviorStandardScene: PackedScene = preload("res://src/edible/behavior/edible_behavior_standard.tscn")
var EdibleBehaviorRandomSizeScene: PackedScene = preload("res://src/edible/behavior/edible_behavior_random_size.tscn")
var EdibleExplosionScene: PackedScene = preload("res://src/edible/effect/edible_explosion.tscn")

@onready var edibles: Node2D = $Edibles

enum LevelEdge {
	Right,
	Top,
	Left,
	Bottom,
}

var viewport_rect: Rect2

func _ready() -> void:
	viewport_rect = get_viewport_rect()

func get_random_position_for_edge(edge: LevelEdge) -> Vector2:
	var from: Vector2
	var to: Vector2
	
	match edge:
		LevelEdge.Left:
			from = Vector2(
				viewport_rect.position.x,
				viewport_rect.position.y,
			)
			to = Vector2(
				viewport_rect.position.x,
				viewport_rect.position.y + viewport_rect.size.y,
			)
		LevelEdge.Right:
			from = Vector2(
				viewport_rect.position.x + viewport_rect.size.x,
				viewport_rect.position.y,
			)
			to = Vector2(
				viewport_rect.position.x + viewport_rect.size.x,
				viewport_rect.position.y + viewport_rect.size.y,
			)
		LevelEdge.Top:
			from = Vector2(
				viewport_rect.position.x,
				viewport_rect.position.y,
			)
			to = Vector2(
				viewport_rect.position.x + viewport_rect.size.x,
				viewport_rect.position.y,
			)
		LevelEdge.Bottom:
			from = Vector2(
				viewport_rect.position.x,
				viewport_rect.position.y + viewport_rect.size.y,
			)
			to = Vector2(
				viewport_rect.position.x + viewport_rect.size.x,
				viewport_rect.position.y + viewport_rect.size.y,
			)
		_:
			from = Vector2.ZERO
			to = Vector2.ZERO
	
	return from.lerp(to, randf_range(0.1, 0.9))

func spawn_edible(edge: LevelEdge) -> void:
	var edible_position: Vector2 = get_random_position_for_edge(edge)
	
	var edible: Edible = EdibleScene.instantiate() as Edible
	var behavior: EdibleBehaviorStandard = EdibleBehaviorStandardScene.instantiate() as EdibleBehaviorStandard
	var behavior_size: EdibleBehaviorRandomSize = EdibleBehaviorRandomSizeScene.instantiate() as EdibleBehaviorRandomSize
	
	edible.position = edible_position
	behavior.edible = edible
	behavior.from_edge = edge
	
	behavior_size.edible = edible
	
	edible.add_child(behavior)
	edible.add_child(behavior_size)
	
	edible.eaten.connect(_on_edible_eaten)
	
	edibles.add_child(edible)

func spawn_explosion(at_edible: Edible) -> void:
	var explosion: EdibleExplosion = EdibleExplosionScene.instantiate() as EdibleExplosion
	explosion.position = at_edible.position
	add_child(explosion)

func get_random_edge() -> LevelEdge:
	var values: Array = LevelEdge.values()
	return values[randi() % len(values)]

func _on_edible_eaten(edible: Edible) -> void:
	edible_eaten.emit()
	spawn_explosion(edible)

func get_edible_count() -> int:
	return edibles.get_child_count()
