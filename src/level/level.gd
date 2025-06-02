class_name Level
extends Node2D

@onready var timer_restart: Timer = $TimerRestart
@onready var color_rect_death: ColorRect = $CanvasLayerOverlay/ColorRectDeath
@onready var level_camera: LevelCamera = $LevelCamera

func _on_tree_entered() -> void:
	if not Utils.is_mobile():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_tree_exited() -> void:
	if not Utils.is_mobile():
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_timer_restart_timeout() -> void:
	get_tree().reload_current_scene()


func _on_player_died() -> void:
	timer_restart.start()
	
	level_camera.do_shake_impulse()
	
	var tween: Tween = create_tween()
	tween.tween_property(color_rect_death, ^"modulate:a", 0.5, 0.1)
	tween.tween_property(color_rect_death, ^"modulate:a", 0, 0.4)
