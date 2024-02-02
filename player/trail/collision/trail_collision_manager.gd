class_name TrailCollisionManager
extends Node2D

var TrailCollisionAreaScene = preload("res://player/trail/collision/trail_collision_area.tscn")

@export var trail: PlayerTrail

## Keep track of the segments for all the points
##
## Listen on [member trail] for creation and deletion of vertices
var segments: Array[TrailSegment] = []

## Shouldnt be needed there are no dup checks needed ig
var collision_areas := {}

func _ready() -> void:
	trail.vertex_added.connect(_on_point_added)
	trail.vertex_removed.connect(_on_point_removed)

func _on_point_added(point_position: Vector2, index: int):
	# We can't build a segment with 1 point
	if index < 1:
		return
	
	var previous_position = trail.points[index - 1]
	var segment_length = point_position - previous_position
	var segment = TrailSegment.new(previous_position, segment_length)
	
	# link the segments together if possible
	# each segment has a reference to the previous and next segment if applicable
	if len(segments) > 0:
		var previus_segment = segments[len(segments) - 1]
		segment.previous = previus_segment
		previus_segment.next = segment
	
	segments.push_back(segment)
	
	# if we have less than 4 points, a closed shape cant exist
	if index < 3:
		return
	
	check_for_new_areas()
	
	assert(len(segments) == len(trail.points) - 1)

func _on_point_removed() -> void:
	segments.pop_front()
	# unlink the removed segment
	segments[0].previous = null
	assert(
		len(segments) == len(trail.points) - 1 or
		(len(segments) == 0 and len(trail.points) == 0)
	)
	assert(segments[0].previous == null)

#region Collision Areas Construction

## build the actual collision area node
##
## This includes constructing the Polygon
func build_collision_area(from_segment: TrailSegment, intersection_point: Vector2) -> TrailCollisionArea:
	var area := TrailCollisionAreaScene.instantiate() as TrailCollisionArea
	var poly := PackedVector2Array()
	
	var segment = from_segment
	
	# start with the intersection point
	poly.append(intersection_point)
	
	while segment.has_next():
		poly.append(segment.next.origin)
		
		if len(segment.intersections) > 0 and segment != from_segment:
			segment = segment.intersections[0]
		else:
			segment = segment.next
	
	add_child(area)
	
	area.polygon = poly
	
	return area

## for the most recent segment only, go through all segments and if they collide,
## try to create a new polygon shape
func check_for_new_areas() -> void:
	var newest := segments[len(segments) - 1]
	# skip the 2nd newest segment because they would always touch in a single point
	for i in range(len(segments) - 2, -1, -1):
		var current := segments[i]
		
		var possible_intersection = current.get_intersection(newest)
		if possible_intersection != null:
			current.add_intersection(newest)
			build_collision_area(current, possible_intersection)

#endregion
