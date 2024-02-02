class_name TrailCollisionArea
extends Area2D

@export var polygon: PackedVector2Array : set = _set_polygon

@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var timer: Timer = $Timer

func _set_polygon(points: PackedVector2Array) -> void:
	polygon = points
	collision_polygon_2d.polygon = polygon


func _on_timer_timeout() -> void:
	queue_free()

func set_remaining_time(seconds: float) -> void:
	timer.wait_time = seconds
	timer.start()
