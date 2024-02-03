class_name EdibleBehaviorStandard
extends EdibleBehavior

var speed: float
var to_speed: float

var direction_vector: Vector2

var sprite_2d: Sprite2D

var viewport_rect: Rect2

var tween: Tween

var from_edge: EdibleSpawner.LevelEdge

func _ready() -> void:
	super._ready()
	
	await edible.ready
	
	sprite_2d = edible.sprite_2d
	
	viewport_rect = get_viewport_rect()
	
	# This ensures that the direction wont be too close to a multiple of 90 degrees
	var direction: float = get_direction_from_edge(from_edge) + \
		randf_range(PI / 7.0, PI / 3.0) * (1.0 if randi() % 2 == 0 else -1.0)
	speed = randf_range(100.0, 200.0)
	
	direction_vector = Vector2.RIGHT.rotated(direction)
	
	edible.became_edible.connect(_on_became_edible)
	
	tween = create_tween()
	tween.tween_property(self, ^"speed", speed * randf_range(1.5, 1.6), 20.0) \
		.set_ease(Tween.EASE_IN_OUT)

func _process(delta: float) -> void:
	super._process(delta)
	
	sprite_2d.rotate(delta * PI)
	
	edible.position += direction_vector * speed * delta
	if not viewport_rect.has_point(edible.position):
		direction_vector = direction_vector.rotated(PI / 2)
		edible.position = edible.position.clamp(viewport_rect.position, viewport_rect.end)

func get_direction_from_edge(edge: EdibleSpawner.LevelEdge) -> float:
	match edge:
		EdibleSpawner.LevelEdge.Right: return 0.0
		EdibleSpawner.LevelEdge.Top: return PI / 2
		EdibleSpawner.LevelEdge.Left: return PI
		EdibleSpawner.LevelEdge.Bottom: return 3 * PI / 2
		_: return 0.0
		

func _on_became_edible() -> void:
	tween.kill()
	tween = create_tween()
	tween.tween_property(self, ^"speed", speed * 0.4, 0.5) \
		.set_ease(Tween.EASE_IN_OUT)
