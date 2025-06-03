class_name EdibleSpawner
extends Node2D

signal edible_eaten()

@export var level: Level

var Edibles: Array[PackedScene] = [
	preload("res://src/edible/edible_square.tscn"),
	preload("res://src/edible/edible_triangle.tscn"),
	preload("res://src/edible/edible_hexagon.tscn"),
]
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
	
	var edible_scene: PackedScene = Edibles[0]
	if randf() < Global.save.upgrade_triangle_chance.get_current_effect():
		edible_scene = Edibles[1]
		if randf() < Global.save.upgrade_triangle_chance.get_current_effect():
			edible_scene = Edibles[2]
	var edible: Edible = edible_scene.instantiate() as Edible
	
	edible.position = edible_position
	
	var movement_component: EdibleBehaviorStandard = edible.get_movement_component()
	if movement_component:
		movement_component.from_edge = edge
	
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
