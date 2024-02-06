class_name Level
extends Node2D

@onready var reload_timer: Timer = $ReloadTimer

func _on_player_died() -> void:
	reload_timer.start()

func _on_tree_entered() -> void:
	if not Utils.is_mobile():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_tree_exited() -> void:
	if not Utils.is_mobile():
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_reload_timer_timeout() -> void:
	get_tree().reload_current_scene()
