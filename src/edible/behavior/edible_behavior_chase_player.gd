class_name EdibleBehaviorChasePlayer
extends Node

@export var edible: Edible

var speed: float


func _ready() -> void:
	speed = get_speed()


func _physics_process(delta: float) -> void:
	if !can_chase():
		return
	
	var player: Player = get_player()
	if !player:
		return
	
	var direction: Vector2 = (player.position - edible.position).normalized()
	edible.position += direction * speed * delta


func get_player() -> Player:
	return get_tree().get_first_node_in_group(&"player")


func get_speed() -> float:
	return 100 + 400 * Utils.sigmoid(Global.save.stage * 0.005 - 5)


func can_chase() -> bool:
	return !edible.edible
