extends Node

const SAVE_PATH: String = "user://save.tres"

var save: SaveGame = SaveGame.new()

func _ready() -> void:
	save_game()
	
	load_game()

func save_game() -> void:
	ResourceSaver.save(save, SAVE_PATH)

func load_game() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var loaded_save: SaveGame = load(SAVE_PATH) as SaveGame
		if loaded_save != null:
			apply_loaded_save(loaded_save)

func apply_loaded_save(loaded: SaveGame) -> void:
	save.score = loaded.score
	save.stage = loaded.stage
	save.upgrade_trail_length.level = loaded.upgrade_trail_length.level
