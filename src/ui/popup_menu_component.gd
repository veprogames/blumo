class_name PopupMenuComponent
extends Node

@export var popup: Control


func _ready() -> void:
	popup.mouse_filter = Control.MOUSE_FILTER_IGNORE
	popup.scale = Vector2.ZERO
	popup.show()


func _unhandled_input(event: InputEvent) -> void:
	var mouse_event: InputEventMouseButton = event as InputEventMouseButton
	if mouse_event:
		hide_menu()


func show_menu() -> void:
	popup.mouse_filter = Control.MOUSE_FILTER_STOP
	var tween: Tween = create_tween()
	tween.tween_property(popup, ^"scale", Vector2.ONE, 0.5) \
		.set_trans(Tween.TRANS_ELASTIC) \
		.set_ease(Tween.EASE_OUT)


func hide_menu() -> void:
	popup.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var tween: Tween = create_tween()
	tween.tween_property(popup, ^"scale", Vector2.ZERO, 0.3) \
		.set_trans(Tween.TRANS_EXPO) \
		.set_ease(Tween.EASE_OUT)
