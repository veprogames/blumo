extends Node

const SAVE_PATH: String = "user://save.tres"

var save: SaveGame = SaveGame.new()

func _ready() -> void:
	if not OS.has_feature("editor"):
		try_load_game()
	
	save.stage_changed.connect(_on_stage_changed)

func save_game() -> void:
	var serialized: Dictionary = save.serialize()
	var file: FileAccess = FileAccess.open_compressed(SAVE_PATH, FileAccess.WRITE, FileAccess.COMPRESSION_ZSTD)
	if file:
		file.store_var(serialized)
	else:
		push_warning("Error while saving: %d" % file.get_error())

func try_load_game() -> void:
	var file: FileAccess = FileAccess.open_compressed(SAVE_PATH, FileAccess.READ, FileAccess.COMPRESSION_ZSTD)
	
	if not file:
		push_warning("Error loading save: %d" % file.get_error())
		return
	
	var serialized: Dictionary = save.serialize()
	var loaded: Dictionary = file.get_var()
	if loaded is Dictionary:
		serialized.merge(loaded, true)
	save.load_game(serialized)

func _on_stage_changed(_new_stage: int) -> void:
	save_game()
