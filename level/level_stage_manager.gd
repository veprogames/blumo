class_name LevelStageManager
extends Node2D

@export var spawner: EdibleSpawner

var stage: int = 0
## The amount the player this has to eat after being spawned
var remaining: int = 0
## The amount that still needs to be spawned
var remaining_to_spawn: int = 0

const MAX_AT_ONCE: int = 100

func _ready() -> void:
	spawner.edible_eaten.connect(_on_edible_eaten)
	
	start_stage.call_deferred()

func start_stage() -> void:
	remaining = get_total_edibles(stage)
	remaining_to_spawn = get_total_edibles(stage)
	try_spawn_edibles()

func next_stage() -> void:
	stage += 1
	await get_tree().create_timer(2).timeout
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
	if remaining == 0:
		next_stage()
