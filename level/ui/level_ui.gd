class_name LevelUI
extends Control

@onready var label_stage: Label = %LabelStage
@onready var currency_counter_score: CurrencyCounter = %CurrencyCounterScore

func _ready() -> void:
	_on_score_changed(Global.save.score)
	_on_stage_changed(Global.save.stage)
	
	Global.save.score_changed.connect(_on_score_changed)
	Global.save.stage_changed.connect(_on_stage_changed)

func _on_score_changed(new_score: float) -> void:
	currency_counter_score.value = new_score

func _on_stage_changed(new_stage: int) -> void:
	label_stage.text = "Stage %d" % (new_stage + 1)
