class_name Player
extends Area2D

signal died()
signal death_animation_finished()

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player_move: AudioStreamPlayer = $AudioStreamPlayerMove
@onready var audio_stream_player_die: AudioStreamPlayer = $AudioStreamPlayerDie

## Used for getting screen edges
var viewport_rect: Rect2

## Record movements over multiple frames to smoothly rotate the player
##
## This is much more accurate than [method Input.get_last_mouse_velocity]
var movements: Array[Vector2] = []

var t: float = 0
var movement_times: Array[float] = []

## Amount of frames of movement to keep track of
const RECORD_THIS_AMOUNT_OF_MOVEMENTS: int = 8

var dead: bool = false

func _ready() -> void:
	viewport_rect = get_viewport_rect()

func _input(event: InputEvent) -> void:
	var mouse_event: InputEventMouseMotion = event as InputEventMouseMotion
	if mouse_event and not dead:
		var motion: Vector2 = mouse_event.relative
		
		# add motion and clamp to screen edges
		position += motion
		position = position.clamp(
			viewport_rect.position,
			viewport_rect.position + viewport_rect.size
		)

		# record average movements
		movements.push_back(motion)
		movement_times.push_back(t)
		if len(movements) > RECORD_THIS_AMOUNT_OF_MOVEMENTS:
			movements.pop_front()
			movement_times.pop_front()

func _process(delta: float) -> void:
	t += delta
	
	if len(movements) > 0:
		var total_movement: Vector2 = Utils.sum(movements) as Vector2
		
		var average_motion: Vector2 = total_movement / len(movements)
		sprite_2d.rotation = average_motion.angle()
	
		var time_difference: float = t - movement_times[0]
		var velocity: float = (total_movement / time_difference).length()
		
		audio_stream_player_move.volume_db = clampf(
			remap(velocity, 0.0, 20000.0, -40.0, 0.0),
			-70.0,
			-6.0,
		)
		audio_stream_player_move.pitch_scale = clampf(
			remap(velocity, 0.0, 20000.0, 0.1, 3.0),
			0.1,
			5.0,
		)

func die() -> void:
	Global.save_game()
	
	# if not dead already
	if not dead:
		dead = true
		audio_stream_player_move.playing = false
		audio_stream_player_die.play()
		
		play_death_animation()
		
		died.emit()

func play_death_animation() -> void:
	var tween: Tween = create_tween()
	var frames: int = 16
	for i: int in range(frames):
		var amplitude: float = 48.0 / (1.0 + i)
		
		var next_offset: Vector2 = Vector2(
			randf_range(-amplitude, amplitude),
			randf_range(-amplitude, amplitude),
		)
		tween.tween_property(sprite_2d, ^"offset", next_offset, 0.07)
	await tween.finished
	death_animation_finished.emit()
