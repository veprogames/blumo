class_name Player
extends Area2D

signal died()

@onready var sprite_2d: Sprite2D = $Sprite2D

## Used for getting screen edges
var viewport_rect: Rect2

## Record movements over multiple frames to smoothly rotate the player
var movements: Array[Vector2] = []

## Amount of frames of movement to keep track of
const RECORD_THIS_AMOUNT_OF_MOVEMENTS: int = 8

func _ready() -> void:
	viewport_rect = get_viewport_rect()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	var mouse_event: InputEventMouseMotion = event as InputEventMouseMotion
	if mouse_event:
		var motion: Vector2 = mouse_event.relative
		
		# add motion and clamp to screen edges
		position += motion
		position = position.clamp(
			viewport_rect.position,
			viewport_rect.position + viewport_rect.size
		)

		# record average movements
		movements.push_back(motion)
		if len(movements) > RECORD_THIS_AMOUNT_OF_MOVEMENTS:
			movements.pop_front()

func _process(_delta: float) -> void:
	if len(movements) > 0:
		var average_motion: Vector2 = Utils.sum(movements) / len(movements)
		sprite_2d.rotation = average_motion.angle()

func die() -> void:
	died.emit()
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	var edible: Edible = area as Edible
	if edible:
		edible.handle_player_collision(self)
