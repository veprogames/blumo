class_name Edible
extends Area2D

signal became_edible()
signal eaten(edible: Edible)

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var glow: Sprite2D = $Glow

static var EDIBLE_COLOR: Color = Color("#224fff")
var edible: bool = false

func _ready() -> void:
	var previous_scale: Vector2 = sprite_2d.scale
	sprite_2d.scale = Vector2.ZERO
	var tween: Tween = create_tween()
	tween.tween_property(sprite_2d, ^"scale", previous_scale, 1.0) \
		.set_trans(Tween.TRANS_ELASTIC) \
		.set_ease(Tween.EASE_OUT)
	
	glow.modulate = Edible.EDIBLE_COLOR
	glow.modulate.a = 0.0
	sprite_2d.modulate.a *= randf_range(0.6, 0.8)

func _on_area_entered(area: Area2D) -> void:
	if area is TrailCollisionArea and !edible:
		become_edible()

func become_edible() -> void:
	edible = true
	sprite_2d.modulate = Edible.EDIBLE_COLOR
	turn_on_glow()
	became_edible.emit()

func get_value() -> float:
	var base: float = Global.save.stage + 1
	var multiplier: float = Global.save.upgrade_edible_value.get_current_effect()
	return base * multiplier

func eat() -> void:
	Global.save.score += get_value()
	queue_free()
	await tree_exited
	eaten.emit(self)

func handle_player_collision(player: Player) -> void:
	if edible:
		eat()
	else:
		player.die()

func turn_on_glow() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(glow, ^"modulate:a", 1.0, 0.2).set_ease(Tween.EASE_IN_OUT)
