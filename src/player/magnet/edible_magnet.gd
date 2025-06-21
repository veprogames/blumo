class_name EdibleMagnet
extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var collision_shape_2d_shape: CircleShape2D

# This emulates a Set
var edibles: Dictionary[Edible, int] = {}


func _ready() -> void:
	collision_shape_2d_shape = collision_shape_2d.shape as CircleShape2D
	
	if !collision_shape_2d_shape:
		push_warning("[EdibleMagnet] Collision Shape not found!")
		queue_free()
	
	if Global.save.upgrade_magnet_enable.level == 0:
		queue_free()
	
	collision_shape_2d_shape.radius = Global.save.upgrade_magnet_size.get_current_effect()


func _physics_process(delta: float) -> void:
	var strength: float = Global.save.upgrade_magnet_strength.get_current_effect()
	
	for edible: Edible in edibles.keys():
		if !edible.edible:
			continue
		
		var dist: float = global_position.distance_to(edible.global_position)
		dist = minf(1.0, dist / collision_shape_2d_shape.radius)
		var speed: float = remap(dist ** 2, 0.0, 1.0, strength, 0.0)
		edible.position = edible.position.move_toward(global_position, speed * delta)


func _draw() -> void:
	var color: Color = Color(Edible.EDIBLE_COLOR)
	color.a = 0.2
	draw_circle(position, collision_shape_2d_shape.radius, color)


func _on_area_entered(area: Area2D) -> void:
	var edible: Edible = area as Edible
	if edible and edible not in edibles:
		edibles[edible] = 1


func _on_area_exited(area: Area2D) -> void:
	var edible: Edible = area as Edible
	if edible in edibles:
		edibles.erase(edible)
