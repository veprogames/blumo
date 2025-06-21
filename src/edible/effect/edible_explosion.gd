class_name EdibleExplosion
extends GPUParticles2D

@export var tex: Texture2D = preload("res://assets/edible/edible.png")
@export var color: Color = Edible.EDIBLE_COLOR


func _ready() -> void:
	modulate = color
	texture = tex
	restart()


func _on_finished() -> void:
	queue_free()
