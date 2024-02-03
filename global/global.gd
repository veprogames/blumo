extends Node

const SAVE_PATH: String = "user://save.tres"

var save: SaveGame = SaveGame.new()

func _ready() -> void:
	if not OS.is_debug_build():
		try_load_game()
	
	save.stage_changed.connect(_on_stage_changed)

func save_game() -> void:
	ResourceSaver.save(save, SAVE_PATH)

func try_load_game() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var loaded_save: SaveGame = load(SAVE_PATH) as SaveGame
		if loaded_save != null:
			apply_loaded_save(loaded_save)

func apply_loaded_save(loaded: SaveGame) -> void:
	save.score = loaded.score
	save.stage = loaded.stage
	save.upgrade_trail_length.level = loaded.upgrade_trail_length.level

func _on_stage_changed(_new_stage: int) -> void:
	save_game()
