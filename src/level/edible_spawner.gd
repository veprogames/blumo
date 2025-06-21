class_name EdibleSpawner
extends Node2D

signal edible_eaten
signal edible_became_edible

@export var level: Level

var Edibles: Array[PackedScene] = [
	preload("res://src/edible/edible_square.tscn"),
	preload("res://src/edible/edible_triangle.tscn"),
	preload("res://src/edible/edible_hexagon.tscn"),
	preload("res://src/edible/edible_star.tscn"),
]
var EdibleExplosionScene: PackedScene = preload("res://src/edible/effect/edible_explosion.tscn")
var ChaseBehaviorScene: PackedScene = preload("res://src/edible/behavior/Edible_behavior_chase_player.tscn")

@onready var edibles: Node2D = $Edibles
@onready var glowing_edibles: Node2D = $GlowingEdibles

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
	
	var edible_scene: PackedScene = Edibles[0]
	if randf() < Global.save.upgrade_triangle_chance.get_current_effect():
		edible_scene = Edibles[1]
		if randf() < Global.save.upgrade_hexagon_chance.get_current_effect():
			edible_scene = Edibles[2]
			if randf() < Global.save.upgrade_star_chance.get_current_effect():
				edible_scene = Edibles[3]
	var edible: Edible = edible_scene.instantiate() as Edible
	
	edible.position = edible_position
	
	var movement_component: EdibleBehaviorStandard = edible.get_movement_component()
	if movement_component:
		movement_component.from_edge = edge
	
	# randomly attach chase behavior
	var stage: int = maxi(0, Global.save.stage - 100)
	if randf() < minf(0.5, stage * 0.0005):
		var behavior: EdibleBehaviorChasePlayer = ChaseBehaviorScene.instantiate()
		behavior.edible = edible
		edible.add_child(behavior)
	
	edible.eaten.connect(_on_edible_eaten)
	edible.became_edible.connect(_on_edible_became_edible)
	
	edibles.add_child(edible)


func get_random_edge() -> LevelEdge:
	var values: Array = LevelEdge.values()
	return values[randi() % len(values)]


func _on_edible_became_edible(edible: Edible) -> void:
	edible.reparent.call_deferred(glowing_edibles)
	edible_became_edible.emit()


func _on_edible_eaten(_edible: Edible) -> void:
	edible_eaten.emit()


func get_edible_count() -> int:
	return edibles.get_child_count()
