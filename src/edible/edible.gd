class_name Edible
extends Area2D

signal became_edible(edible: Edible)
signal eaten(edible: Edible)

const EdibleExplosionScene: PackedScene = preload("res://src/edible/effect/edible_explosion.tscn")
const MaterialAdditive: CanvasItemMaterial = preload("res://assets/materials/additive_blending.tres")

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
	var color_mult: float = randf_range(0.7, 0.9)
	sprite_2d.modulate.r *= color_mult
	sprite_2d.modulate.g *= color_mult
	sprite_2d.modulate.b *= color_mult


func _on_area_entered(area: Area2D) -> void:
	if edible:
		if area is PlayerCollectorArea:
			eat()
	else:
		if area is Bullet:
			var bullet: Bullet = area as Bullet
			if bullet.active:
				bullet.disappear()
				become_edible()
		elif area is Player:
			(area as Player).die()
		elif area is TrailCollisionArea:
			become_edible()


func become_edible() -> void:
	if edible:
		return
	
	edible = true
	turn_on_glow()
	became_edible.emit(self)


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
	spawn_explosion()
	queue_free()
	await tree_exited
	eaten.emit(self)


func turn_on_glow() -> void:
	material = MaterialAdditive
	
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


func spawn_explosion() -> void:
	var container: Node2D = get_spawnables_container()
	
	if !container:
		push_warning("[Edible] Spawnables container not found!")
		return
	
	var explosion: EdibleExplosion = EdibleExplosionScene.instantiate()
	explosion.position = position
	explosion.tex = sprite_2d.texture
	explosion.color = color
	container.add_child(explosion)


func get_spawnables_container() -> Node2D:
	return get_tree().get_first_node_in_group(&"spawnables")


func get_movement_component() -> EdibleBehaviorStandard:
	return get_node("EdibleBehaviorStandard")
