class_name PlayerTrail
extends Line2D

signal vertex_added(position: Vector2, index: int)
signal vertex_removed()

signal died()

const MIN_VERTEX_DIST: int = 32

@export var player: Player

## The last vertex that was placed
var last_vertex: Vector2
## At what [member t] each vertex was placed. Used for removal
var vertex_times: Array[float] = []
## Elapsed time
var t: float = 0.0

static var TRAIL_LIFETIME: float = 0.4

func _ready() -> void:
	player.died.connect(die)

func _process(delta: float) -> void:
	t += delta
	if player != null:
		global_position = Vector2.ZERO
		try_add_trail_vertex()
		try_remove_first_trail_vertex()

func die() -> void:
	died.emit()
	queue_free()

## Get the position where a new vertex should be placed
func get_vertex_pos() -> Vector2:
	return player.global_position

#region adding vertices

## The Distance to the last vertex should be big enough
## to minimize the amount of vertices and improve performance
func should_add_vertex() -> bool:
	return last_vertex == null or \
		last_vertex.distance_to(get_vertex_pos()) > MIN_VERTEX_DIST

## Add a vertex if [method should_add_vertex] applies
func try_add_trail_vertex() -> void:
	if should_add_vertex():
		var pos: Vector2 = get_vertex_pos()
		self.add_point(pos)
		vertex_times.push_back(t)
		last_vertex = pos
		
		var last_vertex_index: int = len(self.points) - 1
		vertex_added.emit(pos, last_vertex_index)
#endregion

#region removing vertices

## If a certain time has passed, the oldest vertex should be removed
func should_remove_first_vertex() -> bool:
	if len(vertex_times) == 0:
		return false
	return t - vertex_times[0] >= PlayerTrail.TRAIL_LIFETIME

## Remove the first/oldest vertex if [method should_remove_first_vertex] applies
func try_remove_first_trail_vertex() -> void:
	if should_remove_first_vertex():
		self.remove_point(0)
		vertex_times.pop_front()
		vertex_removed.emit()
		assert(len(vertex_times) == len(self.points))
#endregion
