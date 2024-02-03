class_name TrailCollisionManager
extends Node2D

var TrailCollisionAreaScene: PackedScene = preload("res://player/trail/collision/trail_collision_area.tscn")

@export var trail: PlayerTrail

## Keep track of the segments for all the points
##
## Listen on [member trail] for creation and deletion of vertices
var segments: Array[TrailSegment] = []

## Shouldnt be needed there are no dup checks needed ig
var collision_areas: Dictionary = {}

func _ready() -> void:
	trail.died.connect(queue_free)
	trail.vertex_added.connect(_on_point_added)
	trail.vertex_removed.connect(_on_point_removed)

func _process(delta: float) -> void:
	# increase the age of segments,
	# used to set the timer for the areas accordingly
	for segment: TrailSegment in segments:
		segment.age += delta

func _on_point_added(point_position: Vector2, index: int) -> void:
	# We can't build a segment with 1 point
	if index < 1:
		return
	
	var previous_position: Vector2 = trail.points[index - 1]
	var segment_length: Vector2 = point_position - previous_position
	var segment: TrailSegment = TrailSegment.new(previous_position, segment_length)
	
	# link the segments together if possible
	# each segment has a reference to the previous and next segment if applicable
	if len(segments) > 0:
		var previus_segment: TrailSegment = segments[len(segments) - 1]
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
	if len(segments) > 0:
		segments[0].previous = null
	assert(
		len(segments) == len(trail.points) - 1 or
		(len(segments) == 0 and len(trail.points) == 0)
	)

#region Collision Areas Construction

# NOTE:
# This is the best I can come up with right now. It's not optimal
# and there are a lot of "illegal" polygons trying to be constructed
# and some are missing
#
# The underlying mathematical problem is
# Finding enclosed convex polygons in a vector of connected points
# in a performant way
#
# The current approach should be nearly O(n) which is fast enough

## build the actual collision area node
##
## This includes constructing the Polygon
func build_collision_area(from_segment: TrailSegment, intersection_point: Vector2) -> TrailCollisionArea:
	var area: TrailCollisionArea = TrailCollisionAreaScene.instantiate() as TrailCollisionArea
	var poly: PackedVector2Array = PackedVector2Array()
	
	var segment: TrailSegment = from_segment
	
	# start with the intersection point
	poly.append(intersection_point)
	
	# go along the trail towards the end...
	while segment.has_next():
		poly.append(segment.next.origin)
		
		# ... but if we stumble across another intersection that
		# is not the starting one
		if len(segment.intersections) > 0 and segment != from_segment:
			# jump forward to that intersection
			# and continue from there
			segment = segment.intersections[0]
		else:
			# otherwise just go to the next segment
			segment = segment.next
	
	add_child(area)
	
	area.set_remaining_time(PlayerTrail.TRAIL_LIFETIME - from_segment.age)
	area.polygon = poly
	
	return area

## for the most recent segment only, go through all segments and if they collide,
## try to create a new polygon shape
func check_for_new_areas() -> void:
	var newest: TrailSegment = segments[len(segments) - 1]
	# skip the 2nd newest segment because they would always touch in a single point
	# go backwards until the first intersection is found
	for i: int in range(len(segments) - 2, -1, -1):
		var current: TrailSegment = segments[i]
		
		var possible_intersection: Variant = current.get_intersection(newest)
		if possible_intersection != null:
			var intersection: Vector2 = possible_intersection
			
			# add a reference to the segment it intersects
			# for faster lookup
			current.add_intersection(newest)
			build_collision_area(current, intersection)

#endregion
