class_name EdibleSpawner
extends Node2D

@export var level: Level

var EdibleScene: PackedScene = preload("res://edible/edible.tscn")
var EdibleBehaviorStandardScene: PackedScene = preload("res://edible/behavior/edible_behavior_standard.tscn")

enum LevelEdge {
	Right,
	Top,
	Left,
	Bottom,
}

var viewport_rect: Rect2

func _ready() -> void:
	viewport_rect = get_viewport_rect()
	
	await level.ready
	
	spawn_edible(LevelEdge.Left)
	spawn_edible(LevelEdge.Right)
	spawn_edible(LevelEdge.Top)
	spawn_edible(LevelEdge.Bottom)

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
	
	return from.lerp(to, randf())

func spawn_edible(edge: LevelEdge) -> void:
	var edible_position: Vector2 = get_random_position_for_edge(edge)
	
	var edible: Edible = EdibleScene.instantiate() as Edible
	var behavior: EdibleBehaviorStandard = EdibleBehaviorStandardScene.instantiate() as EdibleBehaviorStandard
	
	edible.position = edible_position
	behavior.edible = edible
	behavior.from_edge = edge
	
	edible.add_child(behavior)
	
	level.add_child(edible)
