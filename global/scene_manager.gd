extends Node

@onready var overlay: ColorRect = $CanvasLayer/Overlay

func goto_scene(scene: PackedScene) -> void:
	var tween: Tween = create_tween()
	
	tween.tween_property(overlay, ^"color", Color.BLACK, 0.3) \
		.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(overlay, ^"color", Color(0.0, 0.0, 0.0, 0.0), 0.3) \
		.set_ease(Tween.EASE_IN_OUT)
	
	await tween.step_finished
	
	get_tree().change_scene_to_packed(scene)
	

func quit_game() -> void:
	var tween: Tween = create_tween()
	
	tween.tween_property(overlay, ^"color", Color.BLACK, 0.3) \
		.set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished
	
	get_tree().quit()
