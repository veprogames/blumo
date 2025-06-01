class_name TrailCollisionArea
extends Area2D

@export var polygon: PackedVector2Array : set = _set_polygon

@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var timer: Timer = $Timer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var sound_was_played: bool = false

func _set_polygon(points: PackedVector2Array) -> void:
	polygon = points
	collision_polygon_2d.polygon = polygon

func _on_timer_timeout() -> void:
	queue_free()

func set_remaining_time(seconds: float) -> void:
	timer.wait_time = seconds
	timer.start()

func _on_area_entered(area: Area2D) -> void:
	if sound_was_played:
		return
	
	if area is Edible:
		audio_stream_player.play()
		sound_was_played = true
