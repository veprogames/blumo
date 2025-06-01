class_name EdibleExplosion
extends GPUParticles2D

func _ready() -> void:
	modulate = Edible.EDIBLE_COLOR
	restart()

func _on_finished() -> void:
	queue_free()
