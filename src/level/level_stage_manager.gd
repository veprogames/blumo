class_name LevelStageManager
extends Node2D

signal remaining_changed(new_amount: int)

const StreamLevelUp: AudioStreamWAV = preload("res://assets/level/level_up.wav")

@export var spawner: EdibleSpawner

## The amount the player this has to eat after being spawned
var remaining: int = 0
## The amount that still needs to be spawned
var remaining_to_spawn: int = 0

const MAX_AT_ONCE: int = 100


func _ready() -> void:
	spawner.edible_eaten.connect(_on_edible_eaten)
	spawner.edible_became_edible.connect(_on_edible_became_edible)
	
	start_stage.call_deferred()


func get_stage() -> int:
	return Global.save.stage


func start_stage() -> void:
	remaining = get_total_edibles(get_stage())
	remaining_to_spawn = get_total_edibles(get_stage())
	remaining_changed.emit(remaining)
	try_spawn_edibles()


func next_stage() -> void:
	Global.save.stage += 1
	AudioManager.play_stream(StreamLevelUp)
	await get_tree().create_timer(0.3).timeout
	start_stage()


func get_total_edibles(for_stage: int) -> int:
	return for_stage + 1


func try_spawn_edibles() -> void:
	while spawner.get_edible_count() < MAX_AT_ONCE and remaining_to_spawn > 0:
		spawner.spawn_edible(spawner.get_random_edge())
		remaining_to_spawn -= 1


func _on_edible_eaten() -> void:
	try_spawn_edibles()
	remaining -= 1
	
	remaining_changed.emit(remaining)
	
	if remaining == 0:
		next_stage()


func _on_edible_became_edible() -> void:
	try_spawn_edibles.call_deferred()
