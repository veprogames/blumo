class_name MainMenu
extends Node2D

var LevelScene: PackedScene = preload("res://level/level.tscn")

func _on_button_play_pressed() -> void:
	SceneManager.goto_scene(LevelScene)


func _on_button_quit_pressed() -> void:
	SceneManager.quit_game()
