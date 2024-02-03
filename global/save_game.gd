class_name SaveGame
extends Resource

@export var stage: int = 0
@export var score: float = 0.0

@export var upgrade_trail_length: Upgrade = preload("res://global/upgrades/trail_length.tres").duplicate(true)
