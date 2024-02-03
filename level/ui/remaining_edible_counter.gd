class_name RemainingEdibleCounter
extends Label

@export var stage_manager: LevelStageManager

func _ready() -> void:
	text = "%02d" % stage_manager.remaining
	stage_manager.remaining_changed.connect(_on_remaining_changed)

func _on_remaining_changed(new_remaining: int) -> void:
	text = "%02d" % new_remaining
