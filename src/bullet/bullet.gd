class_name Bullet
extends Area2D

const SPEED: float = 800.0

var active: bool = true


func _physics_process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(rotation) * SPEED * delta


func disappear() -> void:
	active = false
	var tween: Tween = create_tween().set_parallel()
	tween.tween_property(self, ^"scale:x", 0.0, 0.1)
	tween.tween_property(self, ^"modulate:a", 0.0, 0.1)
	await tween.finished
	queue_free()
