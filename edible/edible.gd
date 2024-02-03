class_name Edible
extends Area2D

signal became_edible()
signal eaten()

@onready var sprite_2d: Sprite2D = $Sprite2D

const EDIBLE_COLOR: Color = Color("#224fff")
var edible: bool = false

func _ready() -> void:
	var previous_scale: Vector2 = sprite_2d.scale
	sprite_2d.scale = Vector2.ZERO
	var tween: Tween = create_tween()
	tween.tween_property(sprite_2d, ^"scale", previous_scale, 1.0) \
		.set_trans(Tween.TRANS_ELASTIC) \
		.set_ease(Tween.EASE_OUT)
	
	sprite_2d.modulate.a *= randf_range(0.6, 0.8)

func _on_area_entered(area: Area2D) -> void:
	if area is TrailCollisionArea and !edible:
		become_edible()

func become_edible() -> void:
	edible = true
	sprite_2d.modulate *= EDIBLE_COLOR
	became_edible.emit()

func eat() -> void:
	Global.save.score += 1
	queue_free()
	await tree_exited
	eaten.emit()

func handle_player_collision(player: Player) -> void:
	if edible:
		eat()
	else:
		player.die()
