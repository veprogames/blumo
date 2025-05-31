class_name MainMenu
extends Node2D

@onready var currency_counter: CurrencyCounter = $CanvasLayer/VBoxContainer/HBoxContainer/CurrencyCounter

var LevelScene: PackedScene = preload("res://level/level.tscn")

func _ready() -> void:
	update_ui()
	
	Global.save.score_changed.connect(_on_score_changed)

func _on_button_play_pressed() -> void:
	SceneManager.goto_scene(LevelScene)


func _on_button_quit_pressed() -> void:
	SceneManager.quit_game()


func _on_label_subtitle_meta_clicked(meta: Variant) -> void:
	var url: String = meta
	if url != null:
		OS.shell_open(url)

func _on_score_changed(_new_score: float) -> void:
	update_ui()

func update_ui() -> void:
	currency_counter.value = Global.save.score
