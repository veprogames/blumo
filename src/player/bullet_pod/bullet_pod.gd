class_name BulletPod
extends Node2D

const BulletScene: PackedScene = preload("res://src/bullet/bullet.tscn")

var cooldown: float = 0.25
var t: float = 0.0


func _physics_process(delta: float) -> void:
	t += delta
	if t >= cooldown:
		t -= cooldown
		spawn_bullet()


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
