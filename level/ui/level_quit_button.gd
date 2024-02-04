class_name LevelQuitButton
extends Label

const MAX_HOLD_TIME: float = 0.75

@onready var progress_bar: ProgressBar = $ProgressBar

var MainMenuScene: PackedScene = load("res://main_menu/main_menu.tscn")

var hold_time: float = 0.0 : set = _set_hold_time
var holding: bool = false

func _process(delta: float) -> void:
	if Input.is_action_pressed("level_exit"):
		hold_time += delta
		
		if hold_time >= MAX_HOLD_TIME:
			SceneManager.goto_scene(MainMenuScene)
	
	if not Input.is_action_pressed("level_exit"):
		hold_time = 0.0

func _set_hold_time(time: float) -> void:
	hold_time = time
	progress_bar.value = hold_time / MAX_HOLD_TIME
