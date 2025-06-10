class_name EdibleBehaviorStandard
extends Node2D

@export var edible: Edible

var speed: float
var to_speed: float
var rotation_speed: float

var direction_vector: Vector2

var sprite_2d: Sprite2D

var viewport_rect: Rect2

var tween: Tween

var from_edge: EdibleSpawner.LevelEdge


func _ready() -> void:
	await edible.ready
	
	sprite_2d = edible.sprite_2d
	
	viewport_rect = get_viewport_rect()
	
	# This ensures that the direction wont be too close to a multiple of 90 degrees
	var direction: float = get_direction_from_edge(from_edge) + \
		randf_range(PI / 24.0, PI / 6.0) * (1.0 if randi() % 2 == 0 else -1.0)
	speed = get_base_speed() * randf_range(1.0, 1.7)
	
	rotation_speed = speed / 100.0
	
	direction_vector = Vector2.RIGHT.rotated(direction)
	
	edible.became_edible.connect(_on_became_edible)
	
	tween = create_tween()
	tween.tween_property(self, ^"speed", speed * randf_range(1.5, 1.6), 20.0) \
		.set_ease(Tween.EASE_IN_OUT)


func _physics_process(delta: float) -> void:
	sprite_2d.rotate(delta * rotation_speed)
	
	edible.position += direction_vector * speed * delta
	if not viewport_rect.has_point(edible.position):
		# reflection based on current angle
		
		# the perpendicular
		var edge_normal: Vector2 = get_edge_normal(edible.position)
		var angle_to_edge_normal: float = direction_vector.angle_to(edge_normal)
		direction_vector = direction_vector.rotated(PI + 2.0 * angle_to_edge_normal)
		
		# ensure that the edible doesn't stay out of bounds for more than 1 frame
		edible.position = edible.position.clamp(viewport_rect.position, viewport_rect.end)


## get a horizontal or vertical vector pointing away from the edge
## using rounding down
func get_edge_normal(for_position: Vector2) -> Vector2:
	var rounded: Vector2 = (for_position / viewport_rect.size).floor()
	return rounded


func get_direction_from_edge(edge: EdibleSpawner.LevelEdge) -> float:
	match edge:
		EdibleSpawner.LevelEdge.Right: return 0.0
		EdibleSpawner.LevelEdge.Top: return PI / 2
		EdibleSpawner.LevelEdge.Left: return PI
		EdibleSpawner.LevelEdge.Bottom: return 3 * PI / 2
		_: return 0.0


func get_base_speed() -> float:
	var stage: int = Global.save.stage - 100
	var multiplier: float = (1 + 2 * Utils.sigmoid(0.02 * stage - 3))
	return 90 * multiplier


func _on_became_edible(_edible: Edible) -> void:
	tween.kill()
	tween = create_tween()
	tween.tween_property(self, ^"speed", speed * 0.4, 0.5) \
		.set_ease(Tween.EASE_IN_OUT)
