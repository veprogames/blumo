class_name Player
extends Area2D

signal died()

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sprite_glow: Sprite2D = $SpriteGlow
@onready var audio_stream_player_die: AudioStreamPlayer = $AudioStreamPlayerDie

const ExplosionScene: PackedScene = preload("res://src/player/explosion/player_explosion.tscn")

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
	sprite_2d.modulate = Edible.EDIBLE_COLOR
	sprite_glow.modulate = Edible.EDIBLE_COLOR


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


func _physics_process(delta: float) -> void:
	t += delta
	
	if len(movements) > 0:
		var total_movement: Vector2 = Utils.sum(movements)
		
		var average_motion: Vector2 = total_movement / len(movements)
		sprite_2d.rotation = average_motion.angle()


func die() -> void:
	if OS.has_feature("editor"):
		return
	
	Global.save_game()
	
	# if not dead already
	if not dead:
		dead = true
		
		died.emit()
		
		var explosion: PlayerExplosion = ExplosionScene.instantiate()
		explosion.position = position
		get_parent().add_child(explosion)
		
		queue_free()
