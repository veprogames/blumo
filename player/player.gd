class_name Player
extends Area2D

signal died()

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player_move: AudioStreamPlayer = $AudioStreamPlayerMove

## Used for getting screen edges
var viewport_rect: Rect2

## Record movements over multiple frames to smoothly rotate the player
# TODO simplify?
var movements: Array[Vector2] = []

## Amount of frames of movement to keep track of
const RECORD_THIS_AMOUNT_OF_MOVEMENTS: int = 8

var mouse_motion_velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	viewport_rect = get_viewport_rect()

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
		
		# set the velocity for _process
		mouse_motion_velocity = mouse_event.velocity

func _process(_delta: float) -> void:
	# TODO simplify?
	if len(movements) > 0:
		var average_motion: Vector2 = Utils.sum(movements) / len(movements)
		sprite_2d.rotation = average_motion.angle()
		
	var velocity: float = Input.get_last_mouse_velocity().length()
	audio_stream_player_move.volume_db = clampf(
		remap(velocity, 0.0, 7000.0, -40.0, 0.0),
		-70.0,
		-6.0,
	)
	audio_stream_player_move.pitch_scale = clampf(
		remap(velocity, 0.0, 7000.0, 0.1, 3.0),
		0.1,
		3.0,
	)

func die() -> void:
	Global.save_game()
	died.emit()
	queue_free()
