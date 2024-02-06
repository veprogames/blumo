class_name EdibleBehaviorRandomSize
extends EdibleBehavior

@export var min_size: float = 0.8
@export var max_size: float = 1.1

func _ready() -> void:
	edible.scale *= randf_range(min_size, max_size)
