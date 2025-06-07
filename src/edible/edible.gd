class_name Edible
extends Area2D

signal became_edible()
signal eaten(edible: Edible)

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var glow: Sprite2D = $Glow

static var EDIBLE_COLOR: Color = Color("#3a5adf")
var edible: bool = false

@export var value_multiplier: float = 1.0
@export var color: Color = Color("#3a5adf")

func _ready() -> void:
	var previous_scale: Vector2 = sprite_2d.scale
	sprite_2d.scale = Vector2.ZERO
	var tween: Tween = create_tween()
	tween.tween_property(sprite_2d, ^"scale", previous_scale, 1.0) \
		.set_trans(Tween.TRANS_ELASTIC) \
		.set_ease(Tween.EASE_OUT)
	
	glow.modulate = color
	glow.modulate.a = 0.0
	sprite_2d.modulate.a *= randf_range(0.6, 0.8)

func _on_area_entered(area: Area2D) -> void:
	if area is TrailCollisionArea and !edible:
		become_edible()
	elif area is Player and not edible:
		(area as Player).die()
	elif area is PlayerCollectorArea and edible:
		eat()

func become_edible() -> void:
	edible = true
	turn_on_glow()
	became_edible.emit()

func get_value() -> float:
	var stage: int = Global.save.stage
	
	var base: float = stage + 1
	var multiplier: float = Global.save.upgrade_edible_value.get_current_effect()
	
	# after stage 100, standardbehavior edibles will get faster
	# so another boost is introduced :)
	var late_game_boost: float = 1.01 ** maxi(0, stage - 100)
	
	return base * multiplier * late_game_boost * value_multiplier

func eat() -> void:
	Global.save.score += get_value()
	queue_free()
	await tree_exited
	eaten.emit(self)

func turn_on_glow() -> void:
	var tween_glow: Tween = create_tween()
	var tween_sprite: Tween = create_tween()
	tween_glow.tween_property(glow, ^"modulate", color * 2, 0.1) \
		.set_ease(Tween.EASE_IN) \
		.set_trans(Tween.TRANS_EXPO)
	tween_glow.tween_property(glow, ^"modulate", color, 0.7) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_EXPO)
	tween_sprite.tween_property(sprite_2d, ^"modulate", color, 0.8) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_EXPO)

func get_movement_component() -> EdibleBehaviorStandard:
	return get_node("EdibleBehaviorStandard")
