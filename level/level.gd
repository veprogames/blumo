class_name Level
extends Node2D


func _on_player_died() -> void:
	await get_tree().create_timer(2).timeout
	get_tree().reload_current_scene()
