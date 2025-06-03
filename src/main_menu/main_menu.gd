class_name MainMenu
extends Node2D

@onready var upgrade_menu: UpgradeMenu = $CanvasLayer/UpgradeMenu

var LevelScene: PackedScene = preload("res://src/level/level.tscn")


func _on_button_play_pressed() -> void:
	SceneManager.goto_scene(LevelScene)


func _on_button_quit_pressed() -> void:
	SceneManager.quit_game()


func _on_label_subtitle_meta_clicked(meta: Variant) -> void:
	var url: String = meta
	if url != null:
		OS.shell_open(url)


func _on_button_upgrades_pressed() -> void:
	upgrade_menu.show_menu()
