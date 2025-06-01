class_name TrailSegment
extends Object

## From
var origin: Vector2
## [member origin] + [member length] = To
var length: Vector2

## Reference to the previous segment in the trail
var previous: TrailSegment
## Reference to the next segment in the trail
var next: TrailSegment
## Reference to all the segment where there are intersections
var intersections: Array[TrailSegment] = []

var age: float = 0.0

func _init(origin_: Vector2, length_: Vector2) -> void:
	self.origin = origin_
	self.length = length_

func get_target_position() -> Vector2:
	return origin + length

func get_intersection(other: TrailSegment) -> Variant:
	return Geometry2D.segment_intersects_segment(
		origin,
		get_target_position(),
		other.origin,
		other.get_target_position()
	)

func intersects_with(other: TrailSegment) -> bool:
	return self.get_intersection(other) != null

func add_intersection(other: TrailSegment) -> void:
	intersections.append(other)

func has_next() -> bool:
	return next != null
