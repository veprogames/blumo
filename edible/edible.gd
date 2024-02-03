class_name Edible
extends Area2D

signal became_edible()

@onready var sprite_2d: Sprite2D = $Sprite2D

const EDIBLE_COLOR: Color = Color("#224fff")
var edible: bool = false

func _ready() -> void:
	sprite_2d.modulate.a *= randf_range(0.6, 0.8)

func _on_area_entered(area: Area2D) -> void:
	if area is TrailCollisionArea:
		become_edible()

func become_edible() -> void:
	edible = true
	sprite_2d.modulate *= EDIBLE_COLOR
	became_edible.emit()

func eat() -> void:
	queue_free()

func handle_player_collision(player: Player) -> void:
	if edible:
		eat()
	else:
		player.die()
