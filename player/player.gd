class_name Player
extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D

var accumulated_motion := Vector2.ZERO
var viewport_rect: Rect2

func _ready() -> void:
	viewport_rect = get_viewport_rect()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	var mouse_event = event as InputEventMouseMotion
	if mouse_event:
		var motion = mouse_event.relative
		position += motion
		position = position.clamp(
			viewport_rect.position,
			viewport_rect.position + viewport_rect.size
		)
		accumulated_motion += motion

func _process(_delta: float) -> void:
	if accumulated_motion.length() >= 5:
		sprite_2d.rotation = accumulated_motion.angle()
	accumulated_motion = Vector2.ZERO
