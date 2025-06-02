class_name PlayerExplosion
extends GPUParticles2D

func _ready() -> void:
	modulate = Edible.EDIBLE_COLOR
	emitting = true
	await finished
	queue_free()


func _process(delta: float) -> void:
	speed_scale = lerpf(speed_scale, 0, delta)
