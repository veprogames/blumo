class_name BulletPod
extends Node2D

const BulletScene: PackedScene = preload("res://src/bullet/bullet.tscn")

var cooldown: float = 0.5
var t: float = 0.0


func _ready() -> void:
	cooldown = get_cooldown()
	if Global.save.upgrade_bullets_enable.level == 0:
		queue_free()


func _physics_process(delta: float) -> void:
	t += delta
	if t >= cooldown:
		t -= cooldown
		spawn_bullet()


func get_cooldown() -> float:
	return 1.0 / Global.save.upgrade_bullets_firerate.get_current_effect()


func spawn_bullet() -> void:
	var container: Node2D = get_container()
	if !container:
		return
	
	var bullet: Bullet = BulletScene.instantiate()
	container.add_child(bullet)
	bullet.rotation = global_rotation
	bullet.position = global_position


func get_container() -> Node2D:
	return get_tree().get_first_node_in_group(&"spawnables")
