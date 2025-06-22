class_name EdibleBehaviorRandomSize
extends Node

@export var edible: Edible

@export var min_size: float = 0.8
@export var max_size: float = 1.1


func _ready() -> void:
	edible.scale *= randf_range(min_size, max_size)
	queue_free()
