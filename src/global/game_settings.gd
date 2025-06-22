class_name GameSettings
extends RefCounted

const SETTINGS_PATH: String = "user://settings.ini"

var eat_particles: bool = true


func save_settings() -> void:
	var file: ConfigFile = ConfigFile.new()
	file.set_value("Game", "eat_particles", eat_particles)
	file.save(SETTINGS_PATH)


func load_settings() -> void:
	var file: ConfigFile = ConfigFile.new()
	if file.load(SETTINGS_PATH) != OK:
		return
	
	eat_particles = file.get_value("Game", "eat_particles")
	
