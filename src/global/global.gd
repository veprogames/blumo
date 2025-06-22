extends Node

const SAVE_PATH: String = "user://save.tres"

var save: SaveGame = SaveGame.new()
var settings: GameSettings = GameSettings.new()


func _ready() -> void:
	if not OS.has_feature("editor"):
		try_load_game()
		settings.load_settings()
	
	save.stage_changed.connect(_on_stage_changed)


func save_game() -> void:
	var serialized: Dictionary = save.serialize()
	var file: FileAccess = FileAccess.open_compressed(SAVE_PATH, FileAccess.WRITE, FileAccess.COMPRESSION_ZSTD)
	if file:
		file.store_var(serialized)
	else:
		push_warning("Error while saving")


func try_load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		print("No Save File found, not loading save game")
		return
	
	var file: FileAccess = FileAccess.open_compressed(SAVE_PATH, FileAccess.READ, FileAccess.COMPRESSION_ZSTD)
	
	if not file:
		push_warning("Error loading save")
		return
	
	var serialized: Dictionary = save.serialize()
	var loaded: Dictionary = file.get_var()
	if loaded is Dictionary:
		serialized.merge(loaded, true)
	save.load_game(serialized)


func _on_stage_changed(_new_stage: int) -> void:
	save_game()
